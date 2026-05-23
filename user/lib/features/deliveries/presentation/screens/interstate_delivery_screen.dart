import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../../../../shared/widgets/sr_delivery_form.dart';
import '../notifiers/delivery_notifier.dart';

class InterstateDeliveryScreen extends ConsumerWidget {
  const InterstateDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SrScreen(
      child: ListView(
        children: [
          const SrTopBar(title: 'Interstate Delivery'),
          const SizedBox(height: 22),
          const Text('Cross-Country', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Reliable logistics across all major cities.', style: TextStyle(color: SrColors.muted)),
          const SizedBox(height: 24),
          
          SrCard(
            child: Column(
              children: [
                _RuleTile(icon: LucideIcons.shieldCheck, label: 'Insurance Included up to ₦100,000'),
                const Divider(color: SrColors.line),
                _RuleTile(icon: LucideIcons.clock, label: 'Delivery within 48-72 Hours'),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          SrDeliveryForm(
            themeColor: SrColors.green,
            onContinue: () => context.push('/delivery-summary'),
          ),
        ],
      ),
    );
  }
}

class _RuleTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _RuleTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: SrColors.green, size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
        ],
      ),
    );
  }
}
