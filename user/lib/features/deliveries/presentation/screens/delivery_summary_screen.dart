import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/delivery_notifier.dart';

class DeliverySummaryScreen extends ConsumerWidget {
  const DeliverySummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(deliveryNotifierProvider);

    ref.listen(deliveryNotifierProvider, (previous, next) {
      if (next.step == DeliveryStep.success) {
        context.go('/delivery-success');
      } else if (next.step == DeliveryStep.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Submission failed')),
        );
      }
    });

    return SrScreen(
      child: ListView(
        children: [
          const SrTopBar(title: 'Confirm Delivery'),
          const SizedBox(height: 12),
          const SrMapPreview(height: 128),
          const SizedBox(height: 14),
          SrCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Delivery Summary', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 20),
                SrLocationRow(
                  label: 'Pickup',
                  value: draft.pickupAddress ?? 'Select current location',
                ),
                const Divider(color: SrColors.line, height: 24),
                SrLocationRow(
                  label: 'Drop-off',
                  value: draft.destinationAddress ?? 'Select destination',
                ),
                const Divider(color: SrColors.line, height: 24),
                SrLocationRow(
                  label: 'Package',
                  value: draft.packageDescription ?? 'Documents • 2kg',
                  icon: LucideIcons.package,
                  color: Colors.white70,
                ),
                if (draft.itemImagePath != null) ...[
                  const Divider(color: SrColors.line, height: 24),
                  Row(
                    children: [
                      const Icon(LucideIcons.camera, color: Colors.white70, size: 18),
                      const SizedBox(width: 12),
                      const Text('Item Snapshot', style: TextStyle(color: SrColors.muted, fontSize: 13, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(File(draft.itemImagePath!), width: 40, height: 40, fit: BoxFit.cover),
                      ),
                    ],
                  ),
                ],
                const Divider(color: SrColors.line, height: 24),
                SrLocationRow(
                  label: 'Recipient',
                  value: (draft.receiverName?.isNotEmpty ?? false) 
                      ? '${draft.receiverName} • ${draft.receiverPhone}'
                      : 'Not specified',
                  icon: LucideIcons.user,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    const Icon(LucideIcons.wallet, color: SrColors.green, size: 18),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    Text(
                      'N${draft.estimatedPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w900, color: SrColors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SrButton(
            label: 'Confirm & Find Rider',
            onPressed: () => context.push('/ai-finding-rider'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
