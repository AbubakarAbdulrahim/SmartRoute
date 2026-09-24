import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../../../../core/models/delivery_model.dart';
import '../../../home/presentation/notifiers/home_notifier.dart';

class OrdersListScreen extends ConsumerWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);

    return SrScreen(
      bottomNavigationBar: SrBottomNav(
        index: 1,
        onSelected: (index) {
          if (index == 0) context.go('/home');
          if (index == 2) {
            final activeId = ref.read(homeNotifierProvider).activeDelivery?.deliveryId;
            if (activeId != null) {
              context.push('/tracking/$activeId');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No active delivery to track')),
              );
            }
          }
          if (index == 3) context.go('/wallet');
          if (index == 4) context.go('/profile');
        },
      ),
      child: Column(
        children: [
          const SrTopBar(
            title: 'My Orders',
            showBack: true,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                if (state.recentOrders.isEmpty)
                  const _EmptyOrders()
                else
                  ...state.recentOrders.map((order) => _OrderCard(order: order)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final DeliveryModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isOngoing = order.status != DeliveryStatus.completed && order.status != DeliveryStatus.cancelled;

    return InkWell(
      onTap: () => context.push('/orders/${order.deliveryId}'),
      child: SrCard(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (isOngoing ? SrColors.green : SrColors.muted).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isOngoing ? LucideIcons.truck : LucideIcons.checkCircle2,
                    color: isOngoing ? SrColors.green : SrColors.muted,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ORDER #${order.deliveryId.substring(0, 8)}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                SrStatusPill(
                  text: order.status == DeliveryStatus.pending_acceptance ? 'PENDING' : order.status.name.toUpperCase(),
                  color: (order.status == DeliveryStatus.pending_acceptance) ? SrColors.amber : (isOngoing ? SrColors.green : SrColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _TimelineMini(pickup: order.pickupAddress, dropoff: order.destinationAddress),
            if (isOngoing) ...[
              const SizedBox(height: 20),
              SrButton(
                label: 'VIEW DETAILS',
                onPressed: () => context.push('/orders/${order.deliveryId}'),
                secondary: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}


class _TimelineMini extends StatelessWidget {
  final String pickup;
  final String dropoff;
  const _TimelineMini({required this.pickup, required this.dropoff});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimelineRow(icon: LucideIcons.circle, color: SrColors.green, text: pickup),
        Padding(
          padding: const EdgeInsets.only(left: 3.5),
          child: Container(width: 1, height: 16, color: SrColors.line),
        ),
        _TimelineRow(icon: LucideIcons.mapPin, color: SrColors.red, text: dropoff),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _TimelineRow({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 8, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: const Center(
        child: Column(
          children: [
            Icon(LucideIcons.package, color: SrColors.line, size: 64),
            SizedBox(height: 24),
            Text(
              'No orders yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 8),
            Text(
              'Your previous and active deliveries will appear here.',
              style: TextStyle(color: SrColors.muted, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
