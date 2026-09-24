import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../../../../core/models/rider_model.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../notifiers/ai_matching_notifier.dart';

class RiderSelectionScreen extends ConsumerWidget {
  const RiderSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiMatchingNotifierProvider);
    final rankedRiders = state.rankedRiders;

    ref.listen(aiMatchingNotifierProvider, (previous, next) {
      if (next.step == AiMatchingStep.confirmed && previous?.step != AiMatchingStep.confirmed) {
        SrSuccessDialog.show(
          context,
          title: 'Booking Confirmed!',
          subtitle: 'Order ID: ${next.deliveryId}\nTracking ID: ${next.deliveryId}\nYour rider is on the way.',
          onContinue: () => context.go('/tracking/${next.deliveryId}'),
        );
      }
    });

    return SrScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SrTopBar(title: 'AI Smart Match'),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "SmartRoute AI analyzed 50+ riders to find your best matches.",
              style: TextStyle(color: SrColors.muted, fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          if (rankedRiders.isNotEmpty) ...[
            _BestMatchCard(
              rider: rankedRiders[0],
              onTap: () => _showConfirmation(context, ref, rankedRiders[0]),
            ),
            const SizedBox(height: 32),
            const Text(
              "Other Recommendations",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: rankedRiders.length - 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final rider = rankedRiders[index + 1];
                  return _RiderCard(
                    rider: rider,
                    isBest: false,
                    onTap: () => _showConfirmation(context, ref, rider),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 16),
          SrButton(
            label: "Refresh Network",
            onPressed: () {
              ref.read(aiMatchingNotifierProvider.notifier).findRiders();
              context.pushReplacement('/ai-finding-rider');
            },
            secondary: true,
          ),
        ],
      ),
    );
  }

  void _showConfirmation(BuildContext context, WidgetRef ref, RiderModel rider) {
    ref.read(aiMatchingNotifierProvider.notifier).selectRider(rider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ConfirmationModal(rider: rider),
    ).then((confirmed) {
      if (confirmed == true) {
        final userId = ref.read(authNotifierProvider).user?.uid ?? 'guest';
        ref.read(aiMatchingNotifierProvider.notifier).confirmBooking(userId);
      }
    });
  }
}

Future<void> _callRider(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  }
}

class _RiderCard extends StatelessWidget {
  final RiderModel rider;
  final bool isBest;
  final VoidCallback onTap;

  const _RiderCard({
    required this.rider,
    required this.isBest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SrCard(
        borderColor: isBest ? SrColors.green.withValues(alpha: 0.3) : null,
        child: Column(
          children: [
            if (isBest)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: SrColors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.sparkles, size: 14, color: SrColors.green),
                    SizedBox(width: 8),
                    Text(
                      "BEST MATCH",
                      style: TextStyle(
                        color: SrColors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                const SrAvatar(size: 54),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rider.fullName,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(LucideIcons.package, size: 14, color: SrColors.muted),
                          const SizedBox(width: 4),
                          Text(
                            "ID: Rider-${rider.riderId.substring(0, 3).toUpperCase()}",
                            style: const TextStyle(fontSize: 13, color: SrColors.muted, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(LucideIcons.truck, size: 14, color: SrColors.muted),
                          const SizedBox(width: 4),
                          Text(
                            "${rider.vehicleType} • ${rider.plateNumber}",
                            style: const TextStyle(fontSize: 13, color: SrColors.muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(LucideIcons.clock, size: 14, color: SrColors.muted),
                          const SizedBox(width: 4),
                          Text(
                            "${rider.estimatedArrivalMinutes} min away",
                            style: const TextStyle(fontSize: 13, color: SrColors.muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SrIconButton(
                  icon: LucideIcons.phone,
                  onPressed: () => _callRider(rider.phoneNumber),
                  filled: true,
                  color: SrColors.green,
                ),
                const SizedBox(width: 12),
                const Icon(LucideIcons.chevronRight, color: SrColors.line, size: 20),
              ],
            ),
            const Divider(color: SrColors.line, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoItem(label: "Vehicle", value: rider.vehicleType),
                _InfoItem(label: "Success Rate", value: "${(rider.acceptanceRate * 100).toInt()}%"),
                _InfoItem(label: "Deliveries", value: rider.completedDeliveries.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: SrColors.muted, fontSize: 10)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _AiBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00D1FF), Color(0xFF007BFF)],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        children: [
          Icon(LucideIcons.brain, size: 12, color: Colors.white),
          SizedBox(width: 4),
          Text(
            "AI Recommended",
            style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationModal extends StatelessWidget {
  final RiderModel rider;
  const _ConfirmationModal({required this.rider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      decoration: const BoxDecoration(
        color: SrColors.bg2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: SrColors.line)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: SrColors.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          SrAvatar(size: 80, imageUrl: rider.profileImage),
          const SizedBox(height: 16),
          Text(
            rider.fullName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          Text(
            "Rider ID: Rider-${rider.riderId.substring(0, 3).toUpperCase()}",
            style: const TextStyle(color: SrColors.muted, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "${rider.vehicleType} (${rider.plateNumber})",
            style: const TextStyle(color: SrColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            "${rider.estimatedArrivalMinutes} mins away",
            style: const TextStyle(color: SrColors.muted, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SrIconButton(
            icon: LucideIcons.phone,
            onPressed: () => _callRider(rider.phoneNumber),
            filled: true,
            color: SrColors.green,
          ),
          const SizedBox(height: 32),
          SrButton(
            label: "Confirm Booking",
            onPressed: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: SrColors.muted, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _BestMatchCard extends StatelessWidget {
  final RiderModel rider;
  final VoidCallback onTap;

  const _BestMatchCard({required this.rider, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SrCard(
      onTap: onTap,
      color: SrColors.green.withValues(alpha: 0.1),
      borderColor: SrColors.green.withValues(alpha: 0.3),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  SrAvatar(size: 64, imageUrl: rider.profileImage),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: SrColors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.check, color: Colors.white, size: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "PREMIUM CHOICE",
                      style: TextStyle(
                        color: SrColors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rider.fullName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${rider.vehicleType} • ${rider.plateNumber}",
                      style: const TextStyle(color: SrColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _AiBadge(),
            ],
          ),
          const Divider(color: SrColors.line, height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MetricItem(icon: LucideIcons.mapPin, value: "${rider.estimatedArrivalMinutes} min", label: "Arrival"),
              _MetricItem(icon: LucideIcons.package, value: "Rider-${rider.riderId.substring(0, 3).toUpperCase()}", label: "Rider ID"),
              _MetricItem(icon: LucideIcons.shieldCheck, value: "Verified", label: "Status"),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MetricItem({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: SrColors.muted),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
        Text(label, style: const TextStyle(color: SrColors.muted, fontSize: 9)),
      ],
    );
  }
}
