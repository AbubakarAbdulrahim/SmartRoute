import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/address_notifier.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addressNotifierProvider);

    return SrScreen(
      child: Column(
        children: [
          const SrTopBar(title: 'My Addresses', showBack: true),
          Expanded(
            child: state.addresses.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemCount: state.addresses.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.addresses.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: SrButton(
                            label: 'Add New Address',
                            onPressed: () => context.pushNamed('add-address'),
                            secondary: true,
                          ),
                        );
                      }
                      final address = state.addresses[index];
                      return _AddressItem(
                        icon: address.label == 'Home' ? LucideIcons.home : LucideIcons.mapPin,
                        label: address.label,
                        address: address.address,
                        isDefault: address.isDefault,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(LucideIcons.mapPin, size: 48, color: SrColors.line),
        const SizedBox(height: 16),
        const Text('No addresses saved', style: TextStyle(color: SrColors.muted)),
        const SizedBox(height: 24),
        SrButton(
          label: 'Add Your First Address',
          onPressed: () => context.pushNamed('add-address'),
          secondary: true,
        ),
      ],
    );
  }
}

class _AddressItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String address;
  final bool isDefault;

  const _AddressItem({
    required this.icon,
    required this.label,
    required this.address,
    this.isDefault = false,
  });

  @override
  Widget build(BuildContext context) {
    return SrCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: SrColors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: SrColors.green, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    if (isDefault) ...[
                      const SizedBox(width: 8),
                      const SrStatusPill(text: 'DEFAULT', color: SrColors.green),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  address,
                  style: const TextStyle(color: SrColors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.moreVertical, size: 18, color: Colors.white24),
          ),
        ],
      ),
    );
  }
}
