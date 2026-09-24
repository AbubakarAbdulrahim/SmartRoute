import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../features/deliveries/presentation/notifiers/delivery_notifier.dart';
import 'sr_ui.dart';
import 'sr_location_field.dart';
import 'sr_item_image_picker.dart';

class SrDeliveryForm extends ConsumerStatefulWidget {
  final VoidCallback onContinue;
  final Color themeColor;
  final String? category;

  const SrDeliveryForm({
    super.key,
    required this.onContinue,
    this.themeColor = SrColors.green,
    this.category,
  });

  @override
  ConsumerState<SrDeliveryForm> createState() => _SrDeliveryFormState();
}

class _SrDeliveryFormState extends ConsumerState<SrDeliveryForm> {
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();
  String? _selectedCategory = 'Parcel';
  double _weight = 2.0;
  bool _fragile = false;
  String? _imagePath;

  @override
  void dispose() {
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final notifier = ref.read(deliveryNotifierProvider.notifier);
    
    // We assume locations are already being set via SrLocationField's callbacks in the parent or here.
    // For simplicity, we'll just focus on the package details, image, and recipient.
    
    notifier.setPackageDetails(
      description: _selectedCategory ?? 'General Goods',
      weight: _weight,
      category: widget.category,
      imagePath: _imagePath,
      receiverName: _receiverNameController.text,
      receiverPhone: _receiverPhoneController.text,
    );
    
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location Section
        SrLocationField(
          label: 'Pickup Location',
          hint: 'Where should we pick up?',
          icon: LucideIcons.mapPin,
          themeColor: widget.themeColor,
          onSelected: (latLng, address) => ref.read(deliveryNotifierProvider.notifier).setPickup(latLng, address),
        ),
        const SizedBox(height: 16),
        SrLocationField(
          label: 'Destination',
          hint: 'Where is it going?',
          icon: LucideIcons.circleDot,
          themeColor: SrColors.red,
          onSelected: (latLng, address) => ref.read(deliveryNotifierProvider.notifier).setDestination(latLng, address),
        ),
        
        const SizedBox(height: 32),
        const Text('Package Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        
        // Category Selection
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.2,
          children: [
            _CategoryChip(label: 'Documents', icon: LucideIcons.fileText, selected: _selectedCategory == 'Documents', onTap: () => setState(() => _selectedCategory = 'Documents')),
            _CategoryChip(label: 'Parcel', icon: LucideIcons.package, selected: _selectedCategory == 'Parcel', onTap: () => setState(() => _selectedCategory = 'Parcel')),
            _CategoryChip(label: 'Groceries', icon: LucideIcons.shoppingBag, selected: _selectedCategory == 'Groceries', onTap: () => setState(() => _selectedCategory = 'Groceries')),
            _CategoryChip(label: 'Fragile', icon: LucideIcons.box, selected: _selectedCategory == 'Fragile', onTap: () => setState(() => _selectedCategory = 'Fragile')),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Weight Slider
        SrCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Estimated Weight', style: TextStyle(color: SrColors.muted, fontSize: 12)),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _weight,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      activeColor: widget.themeColor,
                      onChanged: (v) => setState(() => _weight = v),
                    ),
                  ),
                  Text('${_weight.toStringAsFixed(0)} kg', style: const TextStyle(fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Fragile Toggle
        SrCard(
          child: SwitchListTile(
            value: _fragile,
            onChanged: (v) => setState(() => _fragile = v),
            activeColor: widget.themeColor,
            contentPadding: EdgeInsets.zero,
            title: const Text('Special handling needed'),
            secondary: Icon(LucideIcons.shieldAlert, color: _fragile ? widget.themeColor : SrColors.muted, size: 20),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Item Photo
        SrItemImagePicker(
          onImagePicked: (path) => setState(() => _imagePath = path),
        ),
        
        const SizedBox(height: 24),
        
        // Recipient Details
        const Text('Recipient Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 16),
        SrCard(
          child: Column(
            children: [
              TextField(
                controller: _receiverNameController,
                style: const TextStyle(fontWeight: FontWeight.w700),
                decoration: const InputDecoration(
                  hintText: "Recipient's Name",
                  hintStyle: TextStyle(color: Colors.white24),
                  prefixIcon: Icon(LucideIcons.user, size: 18, color: SrColors.muted),
                  border: InputBorder.none,
                ),
              ),
              const Divider(color: SrColors.line),
              TextField(
                controller: _receiverPhoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontWeight: FontWeight.w700),
                decoration: const InputDecoration(
                  hintText: "Phone Number",
                  hintStyle: TextStyle(color: Colors.white24),
                  prefixIcon: Icon(LucideIcons.phone, size: 18, color: SrColors.muted),
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Action Button
        SrButton(
          label: 'Continue',
          onPressed: _handleSubmit,
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: selected ? SrColors.green.withValues(alpha: 0.1) : SrColors.panel,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? SrColors.green : SrColors.line, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? SrColors.green : SrColors.muted, size: 18),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w800 : FontWeight.w600, color: selected ? Colors.white : SrColors.muted)),
          ],
        ),
      ),
    );
  }
}
