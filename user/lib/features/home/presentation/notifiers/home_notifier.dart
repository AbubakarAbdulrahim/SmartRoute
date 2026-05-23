import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/delivery_model.dart';
import '../../../../core/models/rider_model.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';

class HomeState {
  final String userName;
  final DeliveryModel? activeDelivery;
  final RiderModel? activeRider;
  final List<DeliveryModel> recentOrders;
  final bool isLoading;

  HomeState({
    this.userName = 'Aisha',
    this.activeDelivery,
    this.activeRider,
    this.recentOrders = const [],
    this.isLoading = false,
  });

  HomeState copyWith({
    String? userName,
    DeliveryModel? activeDelivery,
    RiderModel? activeRider,
    List<DeliveryModel>? recentOrders,
    bool? isLoading,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      activeDelivery: activeDelivery ?? this.activeDelivery,
      activeRider: activeRider ?? this.activeRider,
      recentOrders: recentOrders ?? this.recentOrders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return HomeNotifier(ref.read(firestoreServiceProvider), authState);
});

class HomeNotifier extends StateNotifier<HomeState> {
  final FirestoreService _firestoreService;
  final AuthState _authState;

  HomeNotifier(this._firestoreService, this._authState) : super(HomeState()) {
    _init();
  }

  void _init() {
    state = state.copyWith(isLoading: true);
    
    if (_authState.user != null) {
      state = state.copyWith(userName: _authState.user!.fullName);
      
      // Listen to deliveries for both active and history
      _firestoreService.streamUserDeliveries(_authState.user!.uid, limit: 50).listen((deliveries) {
        if (mounted) {
          final activeDelivery = deliveries.cast<DeliveryModel?>().firstWhere(
            (d) => d!.status == DeliveryStatus.ongoing || d.status == DeliveryStatus.pending || d.status == DeliveryStatus.pending_acceptance,
            orElse: () => null,
          );
          
          state = state.copyWith(
            activeDelivery: activeDelivery,
            recentOrders: deliveries,
            isLoading: false,
          );
        }
      });
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    // Trigger real refresh if needed
    _init();
  }
}
