import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:math' as math;

import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/ai_matching_notifier.dart';
import 'rider_selection_screen.dart';

class AiFindingRiderScreen extends ConsumerStatefulWidget {
  const AiFindingRiderScreen({super.key});

  @override
  ConsumerState<AiFindingRiderScreen> createState() => _AiFindingRiderScreenState();
}

class _AiFindingRiderScreenState extends ConsumerState<AiFindingRiderScreen> with TickerProviderStateMixin {
  late AnimationController _scannerController;
  late AnimationController _textController;
  int _textIndex = 0;

  final List<String> _loadingTexts = [
    "Analyzing nearby riders...",
    "Checking traffic intelligence...",
    "Optimizing delivery assignment...",
    "Finding highest-rated nearby rider...",
    "Gemini AI optimizing routes...",
  ];

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _textController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500)
    );

    _startTextAnimation();

    // Start the search
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiMatchingNotifierProvider.notifier).findRiders();
    });
  }

  void _startTextAnimation() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) break;
      setState(() {
        _textIndex = (_textIndex + 1) % _loadingTexts.length;
      });
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiMatchingNotifierProvider);

    // Navigation logic
    ref.listen(aiMatchingNotifierProvider, (previous, next) {
      if (next.step == AiMatchingStep.results) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RiderSelectionScreen()),
        );
      } else if (next.step == AiMatchingStep.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Search failed')),
        );
        context.pop();
      }
    });

    return SrScreen(
      child: Column(
        children: [
          const SrTopBar(
            title: 'Finding Rider...',
            showBack: true,
          ),
          const Spacer(),
          Stack(
            alignment: Alignment.center,
            children: [
              // Glowing scanning rings
              AnimatedBuilder(
                animation: _scannerController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: List.generate(3, (index) {
                      final progress = (_scannerController.value + (index / 3)) % 1.0;
                      return Container(
                        width: 100 + (progress * 200),
                        height: 100 + (progress * 200),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                          color: SrColors.green.withValues(alpha: (1 - progress) * 0.4),
                          width: 2,
                        ),
                      ),
                      );
                    }),
                  );
                },
              ),
              // Center Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: SrColors.panel,
                  boxShadow: [
                    BoxShadow(
                      color: SrColors.green.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(LucideIcons.cpu, size: 50, color: SrColors.green),
              ),
              // Scanning bar
              AnimatedBuilder(
                animation: _scannerController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _scannerController.value * 2 * math.pi,
                    child: Container(
                      width: 280,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            SrColors.green.withValues(alpha: 0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 60),
          FadeTransition(
            opacity: const AlwaysStoppedAnimation(1),
            child: Text(
              _loadingTexts[_textIndex],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "SmartRoute AI is analyzing real-time data",
            style: TextStyle(color: SrColors.muted, fontSize: 13),
          ),
          const Spacer(),
          SrButton(
            label: 'Cancel Search',
            onPressed: () => context.pop(),
            secondary: true,
          ),
        ],
      ),
    );
  }
}

extension on SrTopBar {
  // Adding onBack if it was missing in the original widget (it used Navigator.maybePop)
  // But wait, SrTopBar in the file uses Navigator.maybePop(context).
  // I'll just use a standard SrTopBar.
}
