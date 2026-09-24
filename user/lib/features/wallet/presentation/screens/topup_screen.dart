import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/wallet_notifier.dart';

class TopUpScreen extends ConsumerStatefulWidget {
  const TopUpScreen({super.key});

  @override
  ConsumerState<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends ConsumerState<TopUpScreen> {
  final _amountController = TextEditingController();
  String _selectedMethod = 'Bank Transfer';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleTopUp() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final success = await ref.read(walletNotifierProvider.notifier).topUp(amount, _selectedMethod);
    if (success && mounted) {
      if (mounted) context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('₦${amount.toStringAsFixed(2)} added to your wallet!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(walletNotifierProvider).isLoading;

    return SrScreen(
      child: Column(
        children: [
          const SrTopBar(title: 'Top Up Wallet', showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                const Text(
                  'ENTER AMOUNT',
                  style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                SrCard(
                  child: Row(
                    children: [
                      const Text('₦', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'PAYMENT METHOD',
                  style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                const SizedBox(height: 12),
                _MethodTile(
                  icon: LucideIcons.landmark,
                  label: 'Bank Transfer',
                  selected: _selectedMethod == 'Bank Transfer',
                  onTap: () => setState(() => _selectedMethod = 'Bank Transfer'),
                ),
                _MethodTile(
                  icon: LucideIcons.creditCard,
                  label: 'Credit Card',
                  selected: _selectedMethod == 'Credit Card',
                  onTap: () => setState(() => _selectedMethod = 'Credit Card'),
                ),
                const SizedBox(height: 40),
                SrButton(
                  label: 'Confirm Top Up',
                  loading: isLoading,
                  onPressed: _handleTopUp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MethodTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SrCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderColor: selected ? SrColors.green : null,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: selected ? SrColors.green : Colors.white70, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: selected ? SrColors.green : Colors.white,
                ),
              ),
            ),
            if (selected)
              const Icon(LucideIcons.checkCircle, color: SrColors.green, size: 18),
          ],
        ),
      ),
    );
  }
}
