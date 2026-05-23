import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../notifiers/auth_notifier.dart';

import '../../../../shared/widgets/sr_ui.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.verificationId, this.phoneNumber = ''});

  final String verificationId;
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  int _secondsRemaining = 45;
  late Timer _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 45;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
          _timer.cancel();
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _verify(WidgetRef ref) async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 4) return;
    
    await ref.read(authNotifierProvider.notifier).verifyOTP(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authNotifierProvider);
        final isLoading = authState.status == AuthStatus.loading;

        ref.listen(authNotifierProvider, (previous, next) {
          if (next.status == AuthStatus.authenticated) {
            SrSuccessDialog.show(
              context,
              title: 'OTP Verified!',
              subtitle: 'Your identity has been verified successfully. Welcome back!',
              onContinue: () => context.go('/home'),
            );
          } else if (next.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(next.errorMessage ?? 'Verification failed')),
            );
          }
        });

        return SrScreen(
          child: ListView(
            children: [
              const SrTopBar(title: 'Delivery OTP', showBack: false),
              const SizedBox(height: 34),
              Center(
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: SrColors.green.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(LucideIcons.lock, color: SrColors.green, size: 38),
                ),
              ),
              const SizedBox(height: 34),
              Text(
                'Enter the OTP sent to\n${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, height: 1.35),
              ),
              const SizedBox(height: 12),
              const Text(
                'Enter OTP to confirm delivery',
                textAlign: TextAlign.center,
                style: TextStyle(color: SrColors.muted),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 52,
                    height: 58,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    child: TextField(
                      controller: _controllers[index],
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: SrColors.panel,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: SrColors.line),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < _controllers.length - 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 26),
              Center(
                child: _canResend
                    ? TextButton(
                        onPressed: () {
                          ref.read(authNotifierProvider.notifier).sendOTP(widget.phoneNumber);
                          _startTimer();
                        },
                        child: const Text('Resend OTP', style: TextStyle(color: SrColors.green, fontWeight: FontWeight.bold)),
                      )
                    : Text(
                        'Resend OTP in 00:${_secondsRemaining.toString().padLeft(2, '0')}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70),
                      ),
              ),
              const SizedBox(height: 40),
              SrCard(
                child: Row(
                  children: const [
                    Icon(LucideIcons.info, color: Colors.white70, size: 18),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'For your security, never share this OTP with anyone.',
                        style: TextStyle(color: SrColors.muted, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SrButton(
                label: 'Verify & Continue',
                loading: isLoading,
                onPressed: () => _verify(ref),
              ),
            ],
          ),
        );
      }
    );
  }
}
