import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/transaction_model.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';

class WalletState {
  final double balance;
  final List<TransactionModel> transactions;
  final bool isLoading;

  WalletState({
    this.balance = 0.0,
    this.transactions = const [],
    this.isLoading = false,
  });

  WalletState copyWith({
    double? balance,
    List<TransactionModel>? transactions,
    bool? isLoading,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final walletNotifierProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return WalletNotifier(ref.read(firestoreServiceProvider), authState);
});

class WalletNotifier extends StateNotifier<WalletState> {
  final FirestoreService _firestoreService;
  final AuthState _authState;

  WalletNotifier(this._firestoreService, this._authState) : super(WalletState()) {
    _init();
  }

  void _init() {
    if (_authState.user != null) {
      state = state.copyWith(balance: _authState.user!.balance);
      _listenToTransactions();
    }
  }

  void _listenToTransactions() {
    if (_authState.user == null) return;
    
    _firestoreService.streamTransactions(_authState.user!.uid).listen((txs) {
      final transactionModels = txs.map((txData) {
        // Handle Firestore timestamp conversion with null safety
        final timestamp = txData['createdAt'] as Timestamp?;
        final createdAt = timestamp?.toDate() ?? DateTime.now();
        return TransactionModel.fromJson({...txData, 'createdAt': createdAt.toIso8601String()});
      }).toList();
      
      state = state.copyWith(transactions: transactionModels);
    });
  }

  Future<bool> topUp(double amount, String paymentMethod) async {
    if (_authState.user == null) return false;
    
    state = state.copyWith(isLoading: true);
    try {
      final newBalance = state.balance + amount;
      await _firestoreService.updateUserBalance(_authState.user!.uid, newBalance);
      
      final txData = {
        'amount': amount,
        'type': TransactionType.topup.name,
        'description': 'Top-up via $paymentMethod',
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _firestoreService.saveTransaction(_authState.user!.uid, txData);
      
      state = state.copyWith(balance: newBalance, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<bool> transfer(double amount, String bankName, String accountNumber) async {
    if (_authState.user == null) return false;
    if (state.balance < amount) return false;
    
    state = state.copyWith(isLoading: true);
    try {
      final newBalance = state.balance - amount;
      await _firestoreService.updateUserBalance(_authState.user!.uid, newBalance);
      
      final txData = {
        'amount': amount,
        'type': TransactionType.transfer.name,
        'description': 'Transfer to $bankName ($accountNumber)',
        'createdAt': FieldValue.serverTimestamp(),
      };
      await _firestoreService.saveTransaction(_authState.user!.uid, txData);
      
      state = state.copyWith(balance: newBalance, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }
}
