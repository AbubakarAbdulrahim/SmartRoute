import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/address_notifier.dart';

class AddAddressScreen extends ConsumerStatefulWidget {
  const AddAddressScreen({super.key});

  @override
  ConsumerState<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<AddAddressScreen> {
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalController = TextEditingController();
  String _selectedLabel = 'Home';

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_addressController.text.isEmpty) return;
    
    await ref.read(addressNotifierProvider.notifier).addAddress(
      label: _selectedLabel,
      address: _addressController.text,
      city: _cityController.text,
      stateRegion: _stateController.text,
      postalCode: _postalController.text,
    );
    
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(addressNotifierProvider).isLoading;

    return SrScreen(
      child: Column(
        children: [
          const SrTopBar(title: 'Add Address', showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                const Text('ADDRESS LABEL', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _LabelChip(
                      label: 'Home',
                      selected: _selectedLabel == 'Home',
                      onTap: () => setState(() => _selectedLabel = 'Home'),
                    ),
                    const SizedBox(width: 8),
                    _LabelChip(
                      label: 'Work',
                      selected: _selectedLabel == 'Work',
                      onTap: () => setState(() => _selectedLabel = 'Work'),
                    ),
                    const SizedBox(width: 8),
                    _LabelChip(
                      label: 'Other',
                      selected: _selectedLabel == 'Other',
                      onTap: () => setState(() => _selectedLabel = 'Other'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('STREET ADDRESS', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                SrCard(
                  child: TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'e.g. 123 Smart Street',
                      suffixIcon: Icon(LucideIcons.mapPin, color: Colors.white24, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('CITY', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          SrCard(
                            child: TextField(
                              controller: _cityController,
                              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Lagos'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('STATE', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          SrCard(
                            child: TextField(
                              controller: _stateController,
                              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Lagos State'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('POSTAL CODE (OPTIONAL)', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                SrCard(
                  child: TextField(
                    controller: _postalController,
                    decoration: const InputDecoration(border: InputBorder.none, hintText: '100001'),
                  ),
                ),
                const SizedBox(height: 40),
                SrButton(
                  label: 'Save Address',
                  loading: isLoading,
                  onPressed: _handleSave,
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.shieldCheck, color: SrColors.green, size: 14),
                    SizedBox(width: 8),
                    Text(
                      'Your address data is saved securely',
                      style: TextStyle(color: SrColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LabelChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? SrColors.green : SrColors.panel,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.transparent : Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
