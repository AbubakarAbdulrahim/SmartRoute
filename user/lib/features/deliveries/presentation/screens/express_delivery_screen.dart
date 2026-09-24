import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../../../../shared/widgets/sr_delivery_form.dart';
import '../notifiers/delivery_notifier.dart';

class ExpressDeliveryScreen extends ConsumerWidget {
  const ExpressDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SrScreen(
      child: ListView(
        children: [
          const SrTopBar(title: 'Express Delivery'),
          const SizedBox(height: 22),
          const Text('Instant Pickup & Delivery', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          const Text('Your item will be picked up within 15 minutes.', style: TextStyle(color: SrColors.muted)),
          const SizedBox(height: 24),
          
          SrDeliveryForm(
            themeColor: SrColors.green,
            category: 'Express Delivery',
            onContinue: () => context.push('/delivery-summary'),
          ),
        ],
      ),
    );
  }
}
