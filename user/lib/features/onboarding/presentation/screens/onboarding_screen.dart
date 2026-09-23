import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/onboarding_notifier.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool _isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SrColors.bg,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D151C),
                    Color(0xFF04070A),
                  ],
                ),
              ),
            ),
          ),
          
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _isLastPage = index == 2);
            },
            children: const [
              _OnboardingPage(
                title: 'Smart Logistics,\nPowered by AI',
                description: 'Create deliveries instantly and let SmartRoute AI intelligently connect you with the best nearby rider.',
                accentColor: SrColors.green,
              ),
              _OnboardingPage(
                title: 'Track Deliveries\nin Real-Time',
                description: 'Watch your rider move live on the map with accurate ETA updates and instant notifications.',
                accentColor: SrColors.amber,
              ),
              _OnboardingPage(
                title: 'Reliable Even\nOffline',
                description: 'SmartRoute AI keeps working even with poor internet using offline synchronization and SMS backup systems.',
                accentColor: SrColors.red,
              ),
            ],
          ),
          
          // Bottom Controls
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: SrColors.green,
                    dotColor: Colors.white10,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 4,
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        ref.read(onboardingNotifierProvider.notifier).completeOnboarding();
                        context.go('/login');
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: SrButton(
                        label: _isLastPage ? 'Get Started' : 'Next',
                        onPressed: () {
                          if (_isLastPage) {
                            ref.read(onboardingNotifierProvider.notifier).completeOnboarding();
                            context.go('/login');
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOutCubic,
                            );
                          }
                        },
                      ),
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

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final Color accentColor;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 120),
          // Subtle Glow behind text
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.15),
                  blurRadius: 100,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
