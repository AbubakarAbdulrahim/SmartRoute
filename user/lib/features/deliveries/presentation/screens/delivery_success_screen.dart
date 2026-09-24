import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/delivery_notifier.dart';

class DeliverySuccessScreen extends ConsumerWidget {
  const DeliverySuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SrScreen(
      child: ListView(
        children: [
          const SrTopBar(title: 'Order Accepted!'),
          const SizedBox(height: 18),
          const Text(
            'Ibrahim is on the way to\npickup your package',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          const SizedBox(height: 22),
          SrCard(
            child: Column(
              children: [
                Row(
                  children: const [
                    SrAvatar(size: 52),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ibrahim Lawal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(LucideIcons.star, color: SrColors.amber, size: 15),
                              SizedBox(width: 4),
                              Text('4.9', style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: SrColors.line, height: 28),
                const _InfoRow(label: 'Rider ID', value: 'SR-RD3487'),
                const SizedBox(height: 12),
                const _InfoRow(label: 'Vehicle', value: 'KTM Boxer'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Expanded(child: Text('Phone', style: TextStyle(color: SrColors.muted))),
                    _RoundAction(icon: LucideIcons.phone, onTap: () {}),
                    const SizedBox(width: 10),
                    _RoundAction(icon: LucideIcons.messageCircle, onTap: () => context.push('/chat')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SrCard(
            child: Row(
              children: const [
                SrMetric(label: 'Estimated Arrival', value: '8 min'),
                SizedBox(width: 14),
                VerticalDivider(color: SrColors.line),
                SizedBox(width: 14),
                SrMetric(label: 'Distance', value: '2.3 km'),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SrButton(
            label: 'Track Order',
            onPressed: () {
              ref.read(deliveryNotifierProvider.notifier).reset();
              context.go('/tracking/SR89372');
            },
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(color: SrColors.muted))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 38,
        height: 38,
        decoration: const BoxDecoration(color: SrColors.green, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
