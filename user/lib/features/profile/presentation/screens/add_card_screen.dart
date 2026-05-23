import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../notifiers/payment_notifier.dart';

class AddCardScreen extends ConsumerStatefulWidget {
  const AddCardScreen({super.key});

  @override
  ConsumerState<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends ConsumerState<AddCardScreen> {
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_cardController.text.length < 16) return;
    if (_expiryController.text.isEmpty) return;
    
    await ref.read(paymentNotifierProvider.notifier).addCard(
      _cardController.text,
      _expiryController.text,
      'Visa', // Mock card type
    );
    
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(paymentNotifierProvider).isLoading;

    return SrScreen(
      child: Column(
        children: [
          const SrTopBar(title: 'Add Credit Card', showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                const Text('CARD NUMBER', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                SrCard(
                  child: TextField(
                    controller: _cardController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0000 0000 0000 0000',
                      suffixIcon: Icon(LucideIcons.creditCard, color: Colors.white24, size: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('EXPIRY DATE', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          SrCard(
                            child: TextField(
                              controller: _expiryController,
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(border: InputBorder.none, hintText: 'MM/YY'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('CVV', style: TextStyle(color: SrColors.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          SrCard(
                            child: TextField(
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              obscureText: true,
                              decoration: const InputDecoration(border: InputBorder.none, hintText: '***'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SrButton(
                  label: 'Securely Add Card',
                  loading: isLoading,
                  onPressed: _handleSave,
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.shieldCheck, color: SrColors.green, size: 14),
                    SizedBox(width: 8),
                    Text(
                      'Your payment data is encrypted and secure',
                      style: TextStyle(color: SrColors.muted, fontSize: 12),
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
