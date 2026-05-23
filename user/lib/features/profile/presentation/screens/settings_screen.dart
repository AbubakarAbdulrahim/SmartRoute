import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/widgets/sr_ui.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SrScreen(
      child: Column(
        children: [
          const SrTopBar(title: 'Settings'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _SettingsSection(
                  title: 'Preferences',
                  items: [
                    _SettingsItem(
                      icon: LucideIcons.bell,
                      label: 'Notifications',
                      trailing: Switch(value: true, onChanged: (v) {}, activeThumbColor: SrColors.green),
                    ),
                    _SettingsItem(
                      icon: LucideIcons.moon,
                      label: 'Dark Mode',
                      trailing: Switch(value: true, onChanged: (v) {}, activeThumbColor: SrColors.green),
                    ),
                    const _SettingsItem(
                      icon: LucideIcons.languages,
                      label: 'Language',
                      value: 'English',
                    ),
                  ],
                ),
                const _SettingsSection(
                  title: 'Security',
                  items: [
                    _SettingsItem(icon: LucideIcons.lock, label: 'Change Password'),
                    _SettingsItem(icon: LucideIcons.shieldCheck, label: 'Two-Factor Authentication'),
                  ],
                ),
                const _SettingsSection(
                  title: 'About',
                  items: [
                    _SettingsItem(icon: LucideIcons.info, label: 'App Version', value: '1.0.0'),
                    _SettingsItem(icon: LucideIcons.fileText, label: 'Terms of Service'),
                    _SettingsItem(icon: LucideIcons.shieldAlert, label: 'Privacy Policy'),
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

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: SrColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SrCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;

  const _SettingsItem({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: trailing == null ? () {} : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white70),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: const TextStyle(color: SrColors.muted, fontSize: 13),
              ),
            if (trailing != null)
              trailing!
            else if (value == null)
              const Icon(LucideIcons.chevronRight, size: 16, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
