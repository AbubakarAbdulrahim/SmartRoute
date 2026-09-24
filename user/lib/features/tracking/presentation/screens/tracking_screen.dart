import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/models/delivery_model.dart';
import '../notifiers/tracking_notifier.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key, required this.deliveryId});

  final String deliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryStream = ref.watch(deliveryStreamProvider(deliveryId));

    ref.listen(deliveryStreamProvider(deliveryId), (previous, next) {
      next.whenData((delivery) {
        if (delivery?.status == DeliveryStatus.completed && 
            previous?.value?.status != DeliveryStatus.completed) {
          SrSuccessDialog.show(
            context,
            title: 'Package Delivered!',
            subtitle: 'Excellent! Your delivery has been completed successfully. Thank you for using SmartRoute.',
            onContinue: () => context.go('/home'),
          );
        }
      });
    });

    return SrScreen(
      padding: EdgeInsets.zero,
      bottomNavigationBar: SrBottomNav(
        index: 2,
        onSelected: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/orders');
          if (index == 3) context.go('/wallet');
          if (index == 4) context.go('/profile');
        },
      ),
      child: deliveryStream.when(
        data: (delivery) {
          if (delivery == null) return const Center(child: Text("Delivery not found"));
          
          final riderLocation = delivery.riderId != null 
              ? ref.watch(riderLocationProvider(delivery.riderId!))
              : const AsyncValue<Map<String, dynamic>>.data({});

          Offset? riderPos;
          riderLocation.whenData((data) {
            if (data.containsKey('lat') && data.containsKey('lng')) {
              // Map normalization dummy (12.0 -> 0.0 to 1.0 range)
              // In production, this would use a real projection
              riderPos = Offset(0.5 + (data['lng'] - 8.59) * 10, 0.5 - (data['lat'] - 12.0) * 10);
            }
          });

          final isPending = delivery.status == DeliveryStatus.pending_acceptance;
          
          return Stack(
            children: [
              Positioned.fill(
                child: SrMapPreview(
                  height: double.infinity, 
                  showRider: !isPending, 
                  full: true,
                  riderPosition: riderPos,
                )
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 96),
                  child: Column(
                    children: [
                      SrTopBar(
                        title: isPending ? 'Awaiting Rider Acceptance' : 'Live Tracking',
                        trailing: SrIconButton(icon: LucideIcons.refreshCw, onPressed: () {}),
                      ),
                      const Spacer(),
                      SrCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: const Text('Your Package', style: TextStyle(color: SrColors.muted, fontSize: 12)),
                                ),
                                SrStatusPill(
                                  text: isPending ? 'PENDING' : 'IN TRANSIT',
                                  color: isPending ? SrColors.amber : SrColors.green,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '#$deliveryId',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                                ),
                                InkWell(
                                  onTap: () => context.push('/orders/$deliveryId'),
                                  child: const Text(
                                    'DETAILS',
                                    style: TextStyle(color: SrColors.green, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${delivery.pickupAddress} → ${delivery.destinationAddress}',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const Divider(color: SrColors.line, height: 24),
                            if (isPending) ...[
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: CircularProgressIndicator(strokeWidth: 2, color: SrColors.amber),
                                ),
                              ),
                              const Center(
                                child: Text(
                                  'Waiting for rider to accept your request...',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: SrColors.muted, fontSize: 13),
                                ),
                              ),
                            ] else ...[
                              const Text('Estimated Delivery', style: TextStyle(color: SrColors.muted, fontSize: 11)),
                              const SizedBox(height: 5),
                              const Text('10:24 AM • 12 min away', style: TextStyle(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 20),
                              const _ProgressSteps(),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}

final deliveryStreamProvider = StreamProvider.family<DeliveryModel?, String>((ref, id) {
  return ref.watch(firestoreServiceProvider).watchDelivery(id);
});

class _ProgressSteps extends StatelessWidget {
  const _ProgressSteps();

  @override
  Widget build(BuildContext context) {
    final labels = ['Confirmed', 'Picked Up', 'In Transit', 'Delivered'];
    return Column(
      children: [
        Row(
          children: List.generate(labels.length * 2 - 1, (i) {
            if (i.isOdd) {
              final active = i < 5;
              return Expanded(
                child: Container(
                  height: 3,
                  color: active ? SrColors.green : SrColors.line,
                ),
              );
            }
            final index = i ~/ 2;
            final active = index <= 2;
            return Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: active ? SrColors.green : SrColors.line,
                shape: BoxShape.circle,
              ),
              child: index == 2
                  ? const Icon(LucideIcons.arrowRight, color: Colors.white, size: 12)
                  : null,
            );
          }),
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map((label) => Text(label, style: const TextStyle(color: SrColors.muted, fontSize: 9)))
              .toList(),
        ),
      ],
    );
  }
}
