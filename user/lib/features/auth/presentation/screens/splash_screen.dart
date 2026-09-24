import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:smart_route/features/onboarding/presentation/notifiers/onboarding_notifier.dart';
import 'package:smart_route/features/auth/presentation/notifiers/auth_notifier.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../../../home/presentation/notifiers/home_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _completeSplash();
  }

  void _completeSplash() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    if (!mounted) return;

    final onboardingComplete = ref.read(onboardingNotifierProvider);
    final authState = ref.read(authNotifierProvider);

    if (!onboardingComplete) {
      context.go('/onboarding');
    } else if (authState.status == AuthStatus.authenticated) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: Stack(
        children: [
          // 1. Futuristic Grid/Map Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: _GridPainter(),
              ),
            ),
          ),

          // 2. Animated Particles
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ParticlePainter(_particleController.value),
                );
              },
            ),
          ),

          // 3. Glowing Center Logo & Text
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing Logo
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: SrColors.green.withValues(alpha: .13),
                    shape: BoxShape.circle,
                    border: Border.all(color: SrColors.green.withValues(alpha: 0.1), width: 8),
                    boxShadow: [
                      BoxShadow(
                        color: SrColors.green.withValues(alpha: 0.2),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.packageCheck,
                    color: SrColors.green,
                    size: 64,
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .scale(duration: 1200.ms, begin: const Offset(1, 1), end: const Offset(1.05, 1.05), curve: Curves.easeInOut)
                    .then()
                    .scale(duration: 1200.ms, begin: const Offset(1.05, 1.05), end: const Offset(1, 1), curve: Curves.easeInOut)
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .shimmer(delay: 1.seconds, duration: 1.5.seconds, color: SrColors.green.withValues(alpha: 0.5)),

                const SizedBox(height: 32),

                // Animated Title
                DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText('SmartRoute'),
                    ],
                    isRepeatingAnimation: false,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                const Text(
                  'AI-Powered Logistics Intelligence',
                  style: TextStyle(
                    color: SrColors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ).animate().fadeIn(delay: 1500.ms, duration: 800.ms).moveY(begin: 10, end: 0),
              ],
            ),
          ),

          // 4. Bottom Loading Indicator
          Positioned(
            bottom: 80,
            left: 60,
            right: 60,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation(SrColors.green),
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                  ),
                ).animate().fadeIn(delay: 2000.ms).scaleX(begin: 0, end: 1, duration: 1200.ms),
                const SizedBox(height: 16),
                Text(
                  'Initializing the app...',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ).animate().fadeIn(delay: 2200.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SrColors.green.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    const step = 40.0;
    for (var i = 0.0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (var i = 0.0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ParticlePainter extends CustomPainter {
  final double animationValue;
  final math.Random random = math.Random(42);

  _ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = SrColors.green.withValues(alpha: 0.3);

    for (var i = 0; i < 40; i++) {
      final x = random.nextDouble() * size.width;
      final y = ((random.nextDouble() + animationValue) % 1.0) * size.height;
      final radius = random.nextDouble() * 2 + 1;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
