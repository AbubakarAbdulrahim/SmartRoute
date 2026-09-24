import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/widgets/sr_ui.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SrScreen(
      child: Column(
        children: [
          const SrTopBar(title: 'Help & Support', showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                const _HelpSearch(),
                const SizedBox(height: 28),
                const Text(
                  'TOPICS',
                  style: TextStyle(
                    color: SrColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Column(
                  children: [
                    _HelpItem(icon: LucideIcons.helpCircle, label: 'FAQs'),
                    _HelpItem(icon: LucideIcons.shieldCheck, label: 'Safety Guidelines'),
                    _HelpItem(icon: LucideIcons.truck, label: 'Delivery Issues'),
                    _HelpItem(icon: LucideIcons.wallet, label: 'Payment & Refunds'),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'CONTACT US',
                  style: TextStyle(
                    color: SrColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                SrCard(
                  child: Column(
                    children: [
                      _ContactRow(
                        icon: LucideIcons.messageSquare,
                        label: 'Live Chat',
                        subtitle: 'Average response: 2 mins',
                        onTap: () {},
                      ),
                      Divider(color: Colors.white.withValues(alpha: 0.05), height: 24),
                      _ContactRow(
                        icon: LucideIcons.mail,
                        label: 'Email Support',
                        subtitle: 'support@smartroute.com',
                        onTap: () {},
                      ),
                      Divider(color: Colors.white.withValues(alpha: 0.05), height: 24),
                      _ContactRow(
                        icon: LucideIcons.phone,
                        label: 'Phone Call',
                        subtitle: '+234 800 SMART ROUTE',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpSearch extends StatelessWidget {
  const _HelpSearch();

  @override
  Widget build(BuildContext context) {
    return SrCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: const Row(
        children: [
          Icon(LucideIcons.search, color: SrColors.muted, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'How can we help you?',
                hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HelpItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return SrCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
          const Icon(LucideIcons.chevronRight, color: Colors.white70, size: 18),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: SrColors.panel2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: SrColors.green, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                Text(subtitle, style: const TextStyle(color: SrColors.muted, fontSize: 12)),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: Colors.white24, size: 16),
        ],
      ),
    );
  }
}
