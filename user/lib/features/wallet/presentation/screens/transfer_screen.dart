import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/wallet_notifier.dart';

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  final _bankController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _bankController.dispose();
    super.dispose();
  }

  void _handleTransfer() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid amount')));
      return;
    }
    if (_accountController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid account number')));
      return;
    }
    if (_bankController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter bank name')));
      return;
    }

    final success = await ref.read(walletNotifierProvider.notifier).transfer(
      amount,
      _bankController.text,
      _accountController.text,
    );

    if (success && mounted) {
      if (mounted) context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transfer of ₦${amount.toStringAsFixed(2)} initiated!')),
      );
    } else if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient balance or error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(walletNotifierProvider);

    return SrScreen(
      child: Column(
        children: [
          const SrTopBar(title: 'Transfer to Bank', showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                SrCard(
                   color: SrColors.panel.withValues(alpha: 0.5),
                  child: Column(
                    children: [
                      const Text('AVAILABLE BALANCE', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text('₦${state.balance.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text('BANK NAME', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                SrCard(
                  child: TextField(
                    controller: _bankController,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: 'Select or type bank name'),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('ACCOUNT NUMBER', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                SrCard(
                  child: TextField(
                    controller: _accountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: '0000000000'),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('AMOUNT', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                SrCard(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: '0.00', prefixText: '₦ '),
                  ),
                ),
                const SizedBox(height: 40),
                SrButton(
                  label: 'Send Money',
                  loading: state.isLoading,
                  onPressed: _handleTransfer,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
