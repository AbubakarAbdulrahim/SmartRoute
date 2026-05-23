import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/notification_notifier.dart';
import '../../../../core/models/notification_model.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationNotifierProvider);
    final notifier = ref.read(notificationNotifierProvider.notifier);

    return SrScreen(
      child: Column(
        children: [
          SrTopBar(
            title: 'Notifications',
            actions: [
              if (state.notifications.any((n) => !n.isRead))
                IconButton(
                  onPressed: () => notifier.markAllAsRead(),
                  icon: const Icon(LucideIcons.checkCheck, color: SrColors.green, size: 20),
                  tooltip: 'Mark all as read',
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Segmented Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: state.filter == NotificationFilter.all,
                  onTap: () => notifier.setFilter(NotificationFilter.all),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Orders',
                  selected: state.filter == NotificationFilter.orders,
                  onTap: () => notifier.setFilter(NotificationFilter.orders),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Offers',
                  selected: state.filter == NotificationFilter.offers,
                  onTap: () => notifier.setFilter(NotificationFilter.offers),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: state.isLoading 
              ? const Center(child: CircularProgressIndicator(color: SrColors.green))
              : state.filteredNotifications.isEmpty
                ? _EmptyState()
                : _NotificationList(notifications: state.filteredNotifications),
          ),
        ],
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;
  const _NotificationList({required this.notifications});

  @override
  Widget build(BuildContext context) {
    // Group notifications by date
    final groups = <String, List<NotificationModel>>{};
    for (var n in notifications) {
      final dateStr = _getDateHeader(n.createdAt);
      if (!groups.containsKey(dateStr)) groups[dateStr] = [];
      groups[dateStr]!.add(n);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final date = groups.keys.elementAt(index);
        final list = groups[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12, top: 8),
              child: Text(
                date.toUpperCase(),
                style: const TextStyle(
                  color: SrColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            ...list.map((n) => _NotificationTile(notification: n)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  String _getDateHeader(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) return 'Today';
    if (date.year == now.year && date.month == now.month && date.day == now.day - 1) return 'Yesterday';
    return DateFormat('MMMM dd, yyyy').format(date);
  }
}

class _NotificationTile extends ConsumerWidget {
  final NotificationModel notification;
  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = _getIconColor();

    return SrCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () {
        if (!notification.isRead) {
          ref.read(notificationNotifierProvider.notifier).markAsRead(notification.id);
        }
        if (notification.type == 'order' && notification.metadataId != null) {
          context.push('/orders/${notification.metadataId}');
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getIcon(), color: color, size: 22),
              ),
              if (!notification.isRead)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: SrColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: SrColors.bg, width: 2),
                      boxShadow: [
                        BoxShadow(color: SrColors.green.withValues(alpha: 0.5), blurRadius: 4),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: notification.isRead ? Colors.white70 : Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      DateFormat('h:mm a').format(notification.createdAt),
                      style: const TextStyle(color: SrColors.line, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notification.body,
                  style: TextStyle(
                    color: notification.isRead ? SrColors.muted : Colors.white70,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (notification.type.toLowerCase()) {
      case 'order': return LucideIcons.package;
      case 'wallet': return LucideIcons.wallet;
      case 'offer': return LucideIcons.gift;
      default: return LucideIcons.bell;
    }
  }

  Color _getIconColor() {
    switch (notification.type.toLowerCase()) {
      case 'order': return SrColors.amber;
      case 'wallet': return SrColors.green;
      case 'offer': return const Color(0xFF7C4DFF);
      default: return Colors.white54;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? SrColors.green : SrColors.panel,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.transparent : Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.w800,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.bellOff, size: 64, color: SrColors.line.withValues(alpha: 0.2)),
          const SizedBox(height: 24),
          const Text(
            'All caught up!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            "We'll notify you when something important happens.",
            textAlign: TextAlign.center,
            style: TextStyle(color: SrColors.muted),
          ),
        ],
      ),
    );
  }
}
