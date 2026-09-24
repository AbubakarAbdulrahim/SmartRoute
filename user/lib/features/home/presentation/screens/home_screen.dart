import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../../../../core/models/delivery_model.dart';
import '../notifiers/home_notifier.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);

    return SrScreen(
      bottomNavigationBar: SrBottomNav(
        index: 0,
        onSelected: (index) {
          if (index == 1) {
            context.push('/orders');
          } else if (index == 2) {
            final activeId = ref.read(homeNotifierProvider).activeDelivery?.deliveryId;
            if (activeId != null) {
              context.push('/tracking/$activeId');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No active delivery to track')),
              );
            }
          } else if (index == 3) {
            context.push('/wallet');
          } else if (index == 4) {
            context.push('/profile');
          }
        },
      ),
      child: RefreshIndicator(
        onRefresh: () => ref.read(homeNotifierProvider.notifier).refresh(),
        color: SrColors.green,
        backgroundColor: SrColors.panel,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 92),
          children: [
            _HomeHeader(name: state.userName),
            const SizedBox(height: 20),
            
            // 1. Where to? Search Bar
            _DestinationSearchBar(onTap: () => context.push('/express-delivery')),
            const SizedBox(height: 24),

            // 2. Promotional Banners
            const _PromoCarousel(),
            const SizedBox(height: 28),

            // 3. Service Category Grid
            const _ServiceGrid(),
            const SizedBox(height: 28),
            
            // 4. Live Delivery State
            if (state.activeDelivery != null) ...[
              _ActiveDeliveryCard(
                delivery: state.activeDelivery!,
                rider: state.activeRider,
              ),
              const SizedBox(height: 28),
            ],

            // 5. Recent Orders
            _RecentOrdersSection(orders: state.recentOrders),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends ConsumerWidget {
  final String name;
  const _HomeHeader({required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    return Row(
      children: [
        SrAvatar(size: 48, imageUrl: user?.profileImage),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: const TextStyle(color: SrColors.muted, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              Text(
                user?.fullName ?? 'Guest',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ],
          ),
        ),
        SrIconButton(
          icon: LucideIcons.bell,
          onPressed: () => context.push('/notifications'),
          filled: true,
        ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning';
    if (hour >= 12 && hour < 17) return 'Good Afternoon';
    if (hour >= 17 && hour < 21) return 'Good Evening';
    return 'Good Night';
  }
}

class _DestinationSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  const _DestinationSearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SrColors.panel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(LucideIcons.search, color: SrColors.green, size: 20),
            SizedBox(width: 14),
            Text(
              'Where to?',
              style: TextStyle(color: SrColors.muted, fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Icon(LucideIcons.sliders, color: SrColors.muted, size: 18),
          ],
        ),
      ),
    );
  }
}

class _PromoCarousel extends StatelessWidget {
  const _PromoCarousel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: PageView(
        children: [
          _PromoCard(
            title: 'Interstate Delivery',
            subtitle: 'Deliver across states with\nSmartRoute Express.',
            color: const Color(0xFF007BFF),
            icon: LucideIcons.truck,
          ),
          _PromoCard(
            title: 'Earn with SmartRoute',
            subtitle: 'Join our fleet as a rider\nand start earning today.',
            color: SrColors.green,
            icon: LucideIcons.badgeDollarSign,
          ),
          _PromoCard(
            title: 'Bulk Delivery',
            subtitle: 'Moving large items?\nWe have the right vehicle.',
            color: const Color(0xFFFF4D4D),
            icon: LucideIcons.ship,
          ),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _PromoCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1586769852836-bc069f19e1b6?q=80&w=2670&auto=format&fit=crop'),
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(icon, size: 48, color: Colors.white.withOpacity(0.2)),
        ],
      ),
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Our Services',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.4,
          children: [
            _ServiceCard(
              title: 'Express',
              color: SrColors.green,
              image: 'delivery_express_category_1779454538454.png',
              onTap: () => context.push('/express-delivery'),
            ),
            _ServiceCard(
              title: 'Scheduled',
              color: SrColors.amber,
              image: 'delivery_scheduled_category_1779454555321.png',
              onTap: () => context.push('/scheduled-delivery'),
            ),
            _ServiceCard(
              title: 'Bulk',
              color: SrColors.red,
              image: 'delivery_bulk_category_1779454570083.png',
              onTap: () => context.push('/bulk-delivery'),
            ),
            _ServiceCard(
              title: 'Interstate',
              color: const Color(0xFF00D1FF),
              icon: LucideIcons.globe,
              onTap: () => context.push('/interstate-delivery'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final Color color;
  final String? image;
  final IconData? icon;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.color,
    this.image,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SrColors.panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(LucideIcons.arrowUpRight, color: color, size: 14),
                ),
              ],
            ),
            if (image != null)
              Positioned(
                right: -10,
                bottom: -10,
                child: Opacity(
                  opacity: 0.4,
                  // Since we are in Flutter, we'd normally use Image.asset
                  // But here we'll assume a local path mapping or just keep it simple
                  child: Icon(LucideIcons.package, size: 40, color: color),
                ),
              )
            else if (icon != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(icon, size: 32, color: color.withOpacity(0.2)),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActiveDeliveryCard extends StatelessWidget {
  final dynamic delivery; // DeliveryModel
  final dynamic rider; // RiderModel?

  const _ActiveDeliveryCard({required this.delivery, this.rider});

  @override
  Widget build(BuildContext context) {
    return SrCard(
      borderColor: SrColors.green.withValues(alpha: 0.3),
      color: SrColors.panel.withOpacity(0.9),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: SrColors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Row(
                  children: [
                    Icon(LucideIcons.radio, size: 12, color: SrColors.green),
                    SizedBox(width: 6),
                    Text(
                      'ACTIVE DELIVERY',
                      style: TextStyle(
                        color: SrColors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Text(
                'ETA: 12 mins',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: SrColors.amber),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const SrAvatar(size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rider?.fullName ?? 'Assigned Rider',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                    ),
                    Text(
                      '${delivery.pickupAddress} → ${delivery.destinationAddress}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: SrColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              SrIconButton(
                icon: LucideIcons.chevronRight,
                onPressed: () => context.push('/tracking/${delivery.deliveryId}'),
                filled: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentOrdersSection extends StatelessWidget {
  final List<dynamic> orders; // List<DeliveryModel>

  const _RecentOrdersSection({required this.orders});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent History',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
            ),
            if (orders.isNotEmpty)
              TextButton(
                onPressed: () {},
                child: const Text('See all', style: TextStyle(color: SrColors.green, fontSize: 13, fontWeight: FontWeight.w700)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (orders.isEmpty)
          const _EmptyState()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) => _HistoryCard(order: orders[index]),
          ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final dynamic order;
  const _HistoryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return SrCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: SrColors.bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            order.status == DeliveryStatus.completed ? LucideIcons.packageCheck : LucideIcons.package,
            color: order.status == DeliveryStatus.completed ? SrColors.green : SrColors.muted,
            size: 20,
          ),
        ),
        title: Text(
          'Package #${order.deliveryId.substring(0, 8)}',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
        ),
        subtitle: Text(
          order.status == DeliveryStatus.pending_acceptance ? 'PENDING' : order.status.name.split('_').join(' ').toUpperCase(),
          style: TextStyle(
            color: order.status == DeliveryStatus.pending_acceptance ? SrColors.amber : SrColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(LucideIcons.chevronRight, color: SrColors.line, size: 20),
        onTap: () => context.push('/orders/${order.deliveryId}'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(LucideIcons.packageOpen, size: 64, color: SrColors.line),
            const SizedBox(height: 16),
            const Text(
              'No orders yet',
              style: TextStyle(color: SrColors.muted, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
