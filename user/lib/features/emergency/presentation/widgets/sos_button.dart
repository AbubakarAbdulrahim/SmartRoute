import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/sos_notifier.dart';

class SOSButton extends ConsumerStatefulWidget {
  const SOSButton({super.key});

  @override
  ConsumerState<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends ConsumerState<SOSButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sosState = ref.watch(sosNotifierProvider);

    return GestureDetector(
      onLongPressStart: (_) {
        ref.read(sosNotifierProvider.notifier).setTriggering();
      },
      onLongPressEnd: (_) {
        if (sosState.status == SOSStatus.triggering) {
          ref.read(sosNotifierProvider.notifier).reset();
        }
      },
      onLongPress: () {
        ref.read(sosNotifierProvider.notifier).triggerAlert();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing Glow
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 80 + (20 * _pulseController.value),
                height: 80 + (20 * _pulseController.value),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.3 * (1 - _pulseController.value)),
                ),
              );
            },
          ),
          
          // Main Button
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),

          // Triggering Progress (Indicator during hold)
          if (sosState.status == SOSStatus.triggering)
            const SizedBox(
              width: 75,
              height: 75,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
        ],
      ),
    );
  }
}
