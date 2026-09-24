import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../shared/widgets/sr_ui.dart';
import '../../../../core/models/transaction_model.dart';
import '../notifiers/wallet_notifier.dart';
import '../../../home/presentation/notifiers/home_notifier.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletNotifierProvider);

    return SrScreen(
      bottomNavigationBar: SrBottomNav(
        index: 3,
        onSelected: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/orders');
          if (index == 2) {
            final activeId = ref.read(homeNotifierProvider).activeDelivery?.deliveryId;
            if (activeId != null) {
              context.push('/tracking/$activeId');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No active delivery to track')),
              );
            }
          }
          if (index == 4) context.go('/profile');
        },
      ),
      child: Column(
        children: [
          const SrTopBar(title: 'My Wallet', showBack: true),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                _BalanceCard(balance: state.balance),
                const SizedBox(height: 32),
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                _QuickActions(ref: ref),
                const SizedBox(height: 32),
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                if (state.transactions.isEmpty)
                  const _EmptyTransactions()
                else
                  ...state.transactions.map((tx) => _TransactionTile(tx: tx)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00FF94), Color(0xFF00D1FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF94).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
              ),
              Icon(LucideIcons.wallet, color: Colors.black54, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '₦${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.black,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                'Account Active',
                style: TextStyle(color: Colors.black.withValues(alpha: 0.5), fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final WidgetRef ref;
  const _QuickActions({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionItem(
            icon: LucideIcons.plus,
            label: 'Top Up',
            color: SrColors.green,
            onTap: () {
              context.pushNamed('topup');
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActionItem(
            icon: LucideIcons.send,
            label: 'Transfer',
            color: SrColors.red,
            onTap: () {
              context.pushNamed('transfer');
            },
          ),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SrCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final TransactionModel tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isTopup = tx.type.name == 'topup';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: SrColors.panel,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isTopup ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
          color: isTopup ? SrColors.green : SrColors.red,
          size: 18,
        ),
      ),
      title: Text(
        tx.description,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
      subtitle: Text(
        '${tx.createdAt.day}/${tx.createdAt.month}/${tx.createdAt.year}',
        style: const TextStyle(color: SrColors.muted, fontSize: 11),
      ),
      trailing: Text(
        '${isTopup ? '+' : '-'}₦${tx.amount.toStringAsFixed(0)}',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 15,
          color: isTopup ? SrColors.green : Colors.white,
        ),
      ),
    );
  }
}

class _EmptyTransactions extends StatelessWidget {
  const _EmptyTransactions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Center(
        child: Column(
          children: [
            Icon(LucideIcons.history, color: SrColors.line, size: 48),
            SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(color: SrColors.muted, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
