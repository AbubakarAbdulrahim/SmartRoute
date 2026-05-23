import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../../../../shared/widgets/sr_delivery_form.dart';
import '../notifiers/delivery_notifier.dart';

class BulkDeliveryScreen extends ConsumerStatefulWidget {
  const BulkDeliveryScreen({super.key});

  @override
  ConsumerState<BulkDeliveryScreen> createState() => _BulkDeliveryScreenState();
}

class _BulkDeliveryScreenState extends ConsumerState<BulkDeliveryScreen> {
  String selectedVehicle = 'Van';

  @override
  Widget build(BuildContext context) {
    return SrScreen(
      child: ListView(
        children: [
          const SrTopBar(title: 'Bulk Delivery'),
          const SizedBox(height: 22),
          const Text('Large Shipments', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('For businesses and large household items.', style: TextStyle(color: SrColors.muted)),
          const SizedBox(height: 24),
          
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _VehicleTile(icon: LucideIcons.truck, label: 'Van', selected: selectedVehicle == 'Van', onTap: () => setState(() => selectedVehicle = 'Van')),
              _VehicleTile(icon: LucideIcons.container, label: 'Truck', selected: selectedVehicle == 'Truck', onTap: () => setState(() => selectedVehicle = 'Truck')),
            ],
          ),
          
          const SizedBox(height: 32),
          
          SrDeliveryForm(
            themeColor: SrColors.green,
            category: 'Bulk Delivery',
            onContinue: () => context.push('/delivery-summary'),
          ),
        ],
      ),
    );
  }
}

class _VehicleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _VehicleTile({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SrCard(
        borderColor: selected ? SrColors.green : SrColors.line,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? SrColors.green : Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w900 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
