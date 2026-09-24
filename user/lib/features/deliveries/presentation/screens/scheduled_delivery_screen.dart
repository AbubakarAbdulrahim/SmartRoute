import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../../../../shared/widgets/sr_delivery_form.dart';
import '../notifiers/delivery_notifier.dart';

class ScheduledDeliveryScreen extends ConsumerStatefulWidget {
  const ScheduledDeliveryScreen({super.key});

  @override
  ConsumerState<ScheduledDeliveryScreen> createState() => _ScheduledDeliveryScreenState();
}

class _ScheduledDeliveryScreenState extends ConsumerState<ScheduledDeliveryScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: SrColors.green,
            onPrimary: Colors.black,
            surface: SrColors.panel,
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: SrColors.green,
            onPrimary: Colors.black,
            surface: SrColors.panel,
            onSurface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    return SrScreen(
      child: ListView(
        children: [
          const SrTopBar(title: 'Scheduled Delivery'),
          const SizedBox(height: 22),
          const Text('Plan Ahead', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Choose a specific time for pickup.', style: TextStyle(color: SrColors.muted)),
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: _DateTimeTile(
                  icon: LucideIcons.calendar,
                  label: 'Date',
                  value: selectedDate == null ? 'Select Date' : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _DateTimeTile(
                  icon: LucideIcons.clock,
                  label: 'Time',
                  value: selectedTime == null ? 'Select Time' : selectedTime!.format(context),
                  onTap: _pickTime,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          SrDeliveryForm(
            themeColor: SrColors.green,
            onContinue: () => context.push('/delivery-summary'),
          ),
        ],
      ),
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateTimeTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SrCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: SrColors.green, size: 24),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(color: SrColors.muted, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
