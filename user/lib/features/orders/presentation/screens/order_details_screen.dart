import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SrScreen(
      bottomNavigationBar: SrBottomNav(
        index: 1,
        onSelected: (index) {
          if (index == 0) context.go('/home');
          if (index == 2) context.push('/tracking/SR89372');
          if (index == 3) context.push('/chat');
          if (index == 4) context.push('/profile');
        },
      ),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 92),
        children: const [
          SrTopBar(title: 'Delivery Details'),
          SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text('#SR89372', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              ),
              SrStatusPill(text: 'In Transit'),
            ],
          ),
          SizedBox(height: 6),
          Text('May 20, 2026 - 10:02 AM', style: TextStyle(color: SrColors.muted)),
          SizedBox(height: 18),
          SrCard(
            child: SrTimeline(
              activeIndex: 2,
              items: [
                ('Order Confirmed', '10:02 AM'),
                ('Picked Up', '10:08 AM'),
                ('In Transit', '10:12 AM'),
                ('Out for Delivery', '10:20 AM'),
                ('Delivered', 'Pending'),
              ],
            ),
          ),
          SizedBox(height: 14),
          SrCard(
            child: Column(
              children: [
                SrLocationRow(label: 'Pickup Location', value: 'Kofar Ruwa, Kano'),
                Divider(color: SrColors.line, height: 24),
                SrLocationRow(
                  label: 'Drop-off Location',
                  value: 'Sabon Gari, Kano',
                  icon: LucideIcons.mapPin,
                ),
              ],
            ),
          ),
          SizedBox(height: 14),
          SrButton(label: 'Need Help?', secondary: true, onPressed: null),
        ],
      ),
    );
  }
}
