import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/payment_notifier.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(paymentNotifierProvider);

    return SrScreen(
      child: Column(
        children: [
          const SrTopBar(title: 'Payment Methods', showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                const Text(
                  'LINKED CARDS',
                  style: TextStyle(
                    color: SrColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                if (state.cards.isEmpty)
                  const _EmptyState(message: 'No cards linked')
                else
                  ...state.cards.map((card) => _PaymentItem(
                    icon: LucideIcons.creditCard,
                    label: card.cardNumber,
                    subtitle: 'Expires ${card.expiryDate}',
                    isDefault: card.isDefault,
                  )),
                const SizedBox(height: 24),
                const Text(
                  'OTHER METHODS',
                  style: TextStyle(
                    color: SrColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                _MethodItem(
                  icon: LucideIcons.wallet,
                  label: 'SmartRoute Wallet',
                  subtitle: 'Use your account balance',
                  onTap: () => context.push('/wallet'),
                ),
                const SizedBox(height: 24),
                SrButton(
                  label: 'Add New Card',
                  onPressed: () => context.pushNamed('add-card'),
                  secondary: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(message, style: const TextStyle(color: SrColors.muted, fontSize: 13)),
    );
  }
}

class _PaymentItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isDefault;

  const _PaymentItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.isDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    return SrCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      const SrStatusPill(text: 'DEFAULT', color: SrColors.green),
                    ],
                  ],
                ),
                Text(subtitle, style: const TextStyle(color: SrColors.muted, fontSize: 12)),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: Colors.white24, size: 16),
        ],
      ),
    );
  }
}

class _MethodItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _MethodItem({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SrCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: SrColors.panel2, borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: SrColors.green, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: const TextStyle(color: SrColors.muted, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight, size: 16, color: SrColors.line),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
