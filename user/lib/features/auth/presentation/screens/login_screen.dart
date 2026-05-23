import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/auth_notifier.dart';

enum AuthScreenMode { login, register, forgot }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.initialMode = AuthScreenMode.login});

  final AuthScreenMode initialMode;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AuthScreenMode _mode;
  bool _usePhone = false;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _setMode(AuthScreenMode mode) {
    setState(() {
      _mode = mode;
      _usePhone = false;
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final notifier = ref.read(authNotifierProvider.notifier);
    if (_mode == AuthScreenMode.register) {
      await notifier.registerWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
        _phoneController.text.trim(),
      );
      if (mounted && ref.read(authNotifierProvider).status == AuthStatus.registrationSuccess) {
        SrSuccessDialog.show(
          context,
          title: 'Account Created!',
          subtitle: 'Your profile has been set up successfully. Please login with your credentials.',
          onContinue: () {
            _setMode(AuthScreenMode.login);
            _emailController.clear();
            _passwordController.clear();
          },
        );
      }
      return;
    }
    if (_mode == AuthScreenMode.forgot) {
      await notifier.sendPasswordReset(_emailController.text.trim());
      return;
    }
    if (_usePhone) {
      await notifier.sendOTP(_phoneController.text.trim());
    } else {
      await notifier.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        if (_mode != AuthScreenMode.register) {
          context.go('/home');
        }
      } else if (next.status == AuthStatus.codeSent) {
        context.push('/otp', extra: {
          'verificationId': next.verificationId,
          'phoneNumber': _phoneController.text.trim(),
        });
      } else if (next.status == AuthStatus.unauthenticated &&
          previous?.status == AuthStatus.loading &&
          _mode == AuthScreenMode.forgot) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset link sent')),
        );
        _setMode(AuthScreenMode.login);
      } else if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Authentication failed')),
        );
      }
    });

    final title = switch (_mode) {
      AuthScreenMode.login => 'Welcome back',
      AuthScreenMode.register => 'Create account',
      AuthScreenMode.forgot => 'Reset password',
    };
    final subtitle = switch (_mode) {
      AuthScreenMode.login => 'Sign in to continue your deliveries',
      AuthScreenMode.register => 'Set up your SmartRoute profile',
      AuthScreenMode.forgot => 'We will send a recovery link to your email',
    };
    final button = switch (_mode) {
      AuthScreenMode.login => _usePhone ? 'Send OTP' : 'Login',
      AuthScreenMode.register => 'Create Account',
      AuthScreenMode.forgot => 'Send Reset Link',
    };

    return SrScreen(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const SizedBox(width: 48), // Balance for the back button
              ],
            ),
            const SizedBox(height: 36),
            Center(
              child: Container(
                width: 78,
                height: 78,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: SrColors.green.withValues(alpha: .13), // Updated withOpacity
                  shape: BoxShape.circle,
                  border: Border.all(color: SrColors.green.withValues(alpha: 0.1), width: 8),
                ),
                child: const Icon(LucideIcons.packageCheck, color: SrColors.green, size: 38),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: SrColors.muted, fontSize: 14),
            ),
            const SizedBox(height: 28),
            if (_mode == AuthScreenMode.login)
              _AuthSwitch(
                left: 'Email',
                right: 'Phone',
                rightSelected: _usePhone,
                onChanged: (value) => setState(() => _usePhone = value),
              ),
            if (_mode == AuthScreenMode.login) const SizedBox(height: 16),
            SrCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_mode == AuthScreenMode.register) ...[
                    _field(
                      controller: _nameController,
                      label: 'Full name',
                      icon: LucideIcons.user,
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 14),
                    _field(
                      controller: _phoneController,
                      label: 'Phone number',
                      icon: LucideIcons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Enter phone number' : null,
                    ),
                    const SizedBox(height: 14),
                  ],
                  if (_usePhone && _mode == AuthScreenMode.login)
                    _field(
                      controller: _phoneController,
                      label: 'Phone number',
                      icon: LucideIcons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Enter phone number' : null,
                    )
                  else
                    _field(
                      controller: _emailController,
                      label: 'Email address',
                      icon: LucideIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          value != null && value.contains('@') ? null : 'Enter a valid email',
                    ),
                  if (_mode != AuthScreenMode.forgot && !_usePhone) ...[
                    const SizedBox(height: 14),
                    _field(
                      controller: _passwordController,
                      label: 'Password',
                      icon: LucideIcons.lock,
                      obscure: true,
                      validator: (value) =>
                          value != null && value.length >= 6 ? null : 'Minimum 6 characters',
                    ),
                    if (_mode == AuthScreenMode.register) ...[
                      const SizedBox(height: 14),
                      _field(
                        controller: _confirmPasswordController,
                        label: 'Confirm password',
                        icon: LucideIcons.lock,
                        obscure: true,
                        validator: (value) {
                          if (value != _passwordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                    ],
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (_mode == AuthScreenMode.login && !_usePhone)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _setMode(AuthScreenMode.forgot),
                  child: const Text('Forgot password?', style: TextStyle(color: SrColors.green)),
                ),
              ),
            const SizedBox(height: 16),
            SrButton(
              label: button,
              loading: isLoading,
              onPressed: _submit,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Container(height: 1, color: Colors.white12)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR CONTINUE WITH', style: TextStyle(color: SrColors.muted, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
                Expanded(child: Container(height: 1, color: Colors.white12)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialButton(
                  imageUrl: 'https://img.icons8.com/color/48/000000/facebook-new.png',
                  onTap: () {},
                ),
                const SizedBox(width: 20),
                _SocialButton(
                  imageUrl: 'https://img.icons8.com/color/48/000000/google-logo.png',
                  onTap: () {},
                ),
                const SizedBox(width: 20),
                _SocialButton(
                  imageUrl: 'assets/images/apple.png',
                  isAsset: true,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: TextButton(
                onPressed: () {
                  if (_mode == AuthScreenMode.register) {
                    _setMode(AuthScreenMode.login);
                  } else {
                    _setMode(AuthScreenMode.register);
                  }
                },
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14),
                    children: [
                      TextSpan(
                        text: _mode == AuthScreenMode.register
                            ? 'Already have an account? '
                            : 'New here? ',
                        style: const TextStyle(color: SrColors.muted),
                      ),
                      TextSpan(
                        text: _mode == AuthScreenMode.register ? 'Login' : 'Create an account',
                        style: const TextStyle(color: SrColors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return _AuthField(
      controller: controller,
      label: label,
      icon: icon,
      obscure: obscure,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}

class _AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<_AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<_AuthField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: SrColors.muted, fontSize: 13),
        prefixIcon: Icon(widget.icon, color: SrColors.green, size: 18),
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(
                  _obscureText ? LucideIcons.eye : LucideIcons.eyeOff,
                  color: SrColors.muted,
                  size: 18,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
        filled: true,
        fillColor: SrColors.bg2.withValues(alpha: .56),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SrColors.green, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: SrColors.red, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String imageUrl;
  final bool isAsset;
  final VoidCallback onTap;

  const _SocialButton({
    required this.imageUrl,
    required this.onTap,
    this.isAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 54,
        height: 54,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: SrColors.panel,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: isAsset
            ? Image.asset(
                imageUrl,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(LucideIcons.apple, color: Colors.white, size: 22),
              )
            : Image.network(
                imageUrl,
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(LucideIcons.apple, color: Colors.white, size: 22),
              ),
      ),
    );
  }
}

class _AuthSwitch extends StatelessWidget {
  const _AuthSwitch({
    required this.left,
    required this.right,
    required this.rightSelected,
    required this.onChanged,
  });

  final String left;
  final String right;
  final bool rightSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SrCard(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _item(left, !rightSelected, () => onChanged(false)),
          _item(right, rightSelected, () => onChanged(true)),
        ],
      ),
    );
  }

  Widget _item(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          height: 42,
          decoration: BoxDecoration(
            color: selected ? SrColors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : SrColors.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
