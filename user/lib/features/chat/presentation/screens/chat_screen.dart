import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SrScreen(
      child: Column(
        children: [
          const SrTopBar(title: 'Chat with Rider'),
          const SizedBox(height: 8),
          SrCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: const [
                SrAvatar(size: 44),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ibrahim Lawal', style: TextStyle(fontWeight: FontWeight.w900)),
                      SizedBox(height: 3),
                      Text('Online', style: TextStyle(color: SrColors.green, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(LucideIcons.phone, color: SrColors.green),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Expanded(
            child: Column(
              children: [
                _Bubble(text: "I'm on my way to pickup your package.", time: '10:08 AM'),
                _Bubble(text: 'Okay, thanks!', time: '10:08 AM', mine: true),
                _Bubble(text: "I've picked up the package and on my way.", time: '10:12 AM'),
                _Bubble(text: "Great, I'll be available.", time: '10:12 AM', mine: true),
                _Bubble(text: "I'm 5 minutes away.", time: '10:20 AM'),
              ],
            ),
          ),
          SrCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: const [
                Expanded(
                  child: Text('Type a message...', style: TextStyle(color: SrColors.muted)),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: SrColors.green,
                  child: Icon(LucideIcons.send, color: Colors.white, size: 17),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.time, this.mine = false});

  final String text;
  final String time;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 230),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: mine ? SrColors.green : SrColors.panel,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: const TextStyle(fontSize: 13, height: 1.35)),
            const SizedBox(height: 6),
            Text(time, style: TextStyle(color: mine ? Colors.white70 : SrColors.muted, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
