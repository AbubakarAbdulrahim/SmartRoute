import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../home/presentation/notifiers/home_notifier.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    
    return SrScreen(
      bottomNavigationBar: SrBottomNav(
        index: 4,
        onSelected: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/orders');
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
        },
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 92),
        children: [
          SrTopBar(
            title: 'Profile',
            trailing: SrIconButton(
              icon: LucideIcons.settings, 
              onPressed: () => context.push('/profile/settings'),
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: Stack(
              children: [
                SrAvatar(size: 82, imageUrl: user?.profileImage),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => context.push('/profile/edit'),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: SrColors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: SrColors.bg, width: 2),
                      ),
                      child: const Icon(LucideIcons.pencil, color: Colors.white, size: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              user?.fullName ?? 'Guest', 
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text(
              user?.phoneNumber ?? 'No phone number', 
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 28),
          _ProfileItem(
            icon: LucideIcons.clipboardList, 
            label: 'My Orders',
            onTap: () => context.push('/orders'),
          ),
          _ProfileItem(
            icon: LucideIcons.wallet, 
            label: 'Wallet',
            onTap: () => context.push('/wallet'),
          ),
          _ProfileItem(
            icon: LucideIcons.mapPin, 
            label: 'Addresses',
            onTap: () => context.push('/profile/addresses'),
          ),
          _ProfileItem(
            icon: LucideIcons.creditCard, 
            label: 'Payment Methods',
            onTap: () => context.push('/profile/payments'),
          ),
          _ProfileItem(
            icon: LucideIcons.lifeBuoy, 
            label: 'Help & Support',
            onTap: () => context.push('/profile/help'),
          ),
          _ProfileItem(
            icon: LucideIcons.settings, 
            label: 'Settings',
            onTap: () => context.push('/profile/settings'),
          ),
          const SizedBox(height: 14),
          SrCard(
            child: InkWell(
              onTap: () {
                ref.read(authNotifierProvider.notifier).logout();
                context.go('/login');
              },
              child: const Row(
                children: [
                  Icon(LucideIcons.logOut, color: SrColors.red, size: 19),
                  SizedBox(width: 14),
                  Text('Log Out', style: TextStyle(color: SrColors.red, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SrCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 18),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
            const Icon(LucideIcons.chevronRight, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }
}
