import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../../../../core/models/delivery_model.dart';
import '../../../tracking/presentation/notifiers/tracking_notifier.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String deliveryId;
  const OrderDetailsScreen({super.key, required this.deliveryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryState = ref.watch(deliveryTrackingProvider(deliveryId));

    return deliveryState.when(
      data: (delivery) {
        if (delivery == null) {
          return const SrScreen(
            child: Center(child: Text('Order not found')),
          );
        }

        final isOngoing = delivery.status != DeliveryStatus.completed && delivery.status != DeliveryStatus.cancelled;

        return SrScreen(
          child: Column(
            children: [
              SrTopBar(
                title: 'Order Details',
                trailing: isOngoing ? SrIconButton(
                  icon: LucideIcons.navigation,
                  onPressed: () => context.push('/tracking/${delivery.deliveryId}'),
                ) : null,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  children: [
                    _StatusHeader(delivery: delivery),
                    const SizedBox(height: 24),
                    _PackageInfo(delivery: delivery),
                    const SizedBox(height: 24),
                    _RouteInfo(delivery: delivery),
                    const SizedBox(height: 24),
                    _RecipientInfo(delivery: delivery),
                    const SizedBox(height: 24),
                    _FinancialInfo(delivery: delivery),
                    const SizedBox(height: 40),
                    if (isOngoing)
                      SrButton(
                        label: 'TRACK LIVE',
                        onPressed: () => context.push('/tracking/${delivery.deliveryId}'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SrScreen(child: Center(child: CircularProgressIndicator())),
      error: (e, _) => SrScreen(child: Center(child: Text('Error: $e'))),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final DeliveryModel delivery;
  const _StatusHeader({required this.delivery});

  @override
  Widget build(BuildContext context) {
    final isPending = delivery.status == DeliveryStatus.pending_acceptance;
    return SrCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ORDER #${delivery.deliveryId.substring(0, 8)}',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              SrStatusPill(
                text: isPending ? 'PENDING' : delivery.status.name.toUpperCase(),
                color: isPending ? SrColors.amber : (delivery.status == DeliveryStatus.completed ? SrColors.green : SrColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoLine(label: 'Tracking ID', value: delivery.deliveryId),
          const SizedBox(height: 8),
          _InfoLine(label: 'Booking ID', value: 'BK-${delivery.createdAt?.millisecondsSinceEpoch ?? "N/A"}'),
        ],
      ),
    );
  }
}

class _PackageInfo extends StatelessWidget {
  final DeliveryModel delivery;
  const _PackageInfo({required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Package Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        SrCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (delivery.packageImage != null && File(delivery.packageImage!).existsSync())
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(delivery.packageImage!), width: 80, height: 80, fit: BoxFit.cover),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: SrColors.panel,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.package, color: SrColors.muted),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      delivery.packageCategory ?? 'Standard Delivery',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      delivery.packageDescription ?? 'No description provided',
                      style: const TextStyle(color: SrColors.muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteInfo extends StatelessWidget {
  final DeliveryModel delivery;
  const _RouteInfo({required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Address Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        SrCard(
          child: Column(
            children: [
              _TimelineRow(icon: LucideIcons.circle, color: SrColors.green, label: 'Pickup', value: delivery.pickupAddress),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: SrColors.line, height: 1),
              ),
              _TimelineRow(icon: LucideIcons.mapPin, color: SrColors.red, label: 'Destination', value: delivery.destinationAddress),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecipientInfo extends StatelessWidget {
  final DeliveryModel delivery;
  const _RecipientInfo({required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Recipient Info', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        SrCard(
          child: Column(
            children: [
              _InfoLine(label: 'Name', value: 'John Doe'), // Real value would come from extras or refined model
              const SizedBox(height: 12),
              _InfoLine(label: 'Phone', value: '+234 812 345 6789'),
            ],
          ),
        ),
      ],
    );
  }
}

class _FinancialInfo extends StatelessWidget {
  final DeliveryModel delivery;
  const _FinancialInfo({required this.delivery});

  @override
  Widget build(BuildContext context) {
    return SrCard(
      color: SrColors.green.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total Paid', style: TextStyle(fontWeight: FontWeight.w700)),
          Text(
            '₦${delivery.deliveryFee.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: SrColors.green),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: SrColors.muted, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  const _TimelineRow({required this.icon, required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
