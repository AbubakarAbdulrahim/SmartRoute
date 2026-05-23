import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/otp_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/deliveries/presentation/screens/express_delivery_screen.dart';
import '../features/deliveries/presentation/screens/scheduled_delivery_screen.dart';
import '../features/deliveries/presentation/screens/delivery_summary_screen.dart';
import '../features/deliveries/presentation/screens/delivery_success_screen.dart';
import '../features/deliveries/presentation/screens/ai_finding_rider_screen.dart';
import '../features/deliveries/presentation/screens/rider_selection_screen.dart';
import '../features/tracking/presentation/screens/tracking_screen.dart';
import '../features/notifications/presentation/screens/notification_screen.dart';
import '../features/deliveries/presentation/screens/bulk_delivery_screen.dart';
import '../features/deliveries/presentation/screens/interstate_delivery_screen.dart';
import '../features/wallet/presentation/screens/wallet_screen.dart';
import '../features/wallet/presentation/screens/topup_screen.dart';
import '../features/wallet/presentation/screens/transfer_screen.dart';
import '../features/deliveries/presentation/screens/orders_list_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/profile/presentation/screens/edit_profile_screen.dart';
import '../features/profile/presentation/screens/settings_screen.dart';
import '../features/profile/presentation/screens/addresses_screen.dart';
import '../features/profile/presentation/screens/add_address_screen.dart';
import '../features/profile/presentation/screens/help_support_screen.dart';
import '../features/profile/presentation/screens/payment_methods_screen.dart';
import '../features/profile/presentation/screens/add_card_screen.dart';
import '../features/chat/presentation/screens/chat_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../features/deliveries/presentation/screens/order_details_screen.dart';
import '../features/onboarding/presentation/notifiers/onboarding_notifier.dart';
import '../features/auth/presentation/notifiers/auth_notifier.dart';
import '../shared/widgets/error_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: AuthListenable(ref),
    redirect: (context, state) {
      final onboardingComplete = ref.read(onboardingNotifierProvider);
      final isLoggedIn = ref.read(authNotifierProvider).status == AuthStatus.authenticated;
      final isAuthRoute = state.matchedLocation == '/login' || 
                         state.matchedLocation == '/register' || 
                         state.matchedLocation == '/forgot-password' || 
                         state.matchedLocation == '/otp' ||
                         state.matchedLocation == '/';

      if (!onboardingComplete && state.matchedLocation != '/onboarding' && state.matchedLocation != '/') {
        return '/onboarding';
      }
      
      if (onboardingComplete && state.matchedLocation == '/onboarding') {
        return isLoggedIn ? '/home' : '/login';
      }

      // Protect all other routes
      if (onboardingComplete && !isLoggedIn && !isAuthRoute && state.matchedLocation != '/') {
        return '/login';
      }

      // If logged in and on an auth route (except splash), go home
      if (isLoggedIn && isAuthRoute && state.matchedLocation != '/') {
        return '/home';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _customTransition(state, const SplashScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _customTransition(state, const LoginScreen()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => _customTransition(state, const RegisterScreen()),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) => _customTransition(
          state,
          const LoginScreen(initialMode: AuthScreenMode.forgot),
        ),
      ),
      GoRoute(
        path: '/otp',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return _customTransition(
            state,
            OtpScreen(
              verificationId: extra['verificationId'] as String? ?? '',
              phoneNumber: extra['phoneNumber'] as String? ?? 'your number',
            ),
          );
        },
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => _customTransition(state, const HomeScreen()),
      ),
      GoRoute(
        path: '/delivery-summary',
        pageBuilder: (context, state) => _customTransition(state, const DeliverySummaryScreen()),
      ),
      GoRoute(
        path: '/delivery-success',
        pageBuilder: (context, state) => _customTransition(state, const DeliverySuccessScreen()),
      ),
      GoRoute(
        path: '/ai-finding-rider',
        pageBuilder: (context, state) => _customTransition(state, const AiFindingRiderScreen()),
      ),
      GoRoute(
        path: '/rider-selection',
        pageBuilder: (context, state) => _customTransition(state, const RiderSelectionScreen()),
      ),
      GoRoute(
        path: '/tracking/:id',
        pageBuilder: (context, state) => _customTransition(state, TrackingScreen(deliveryId: state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: '/express-delivery',
        builder: (context, state) => const ExpressDeliveryScreen(),
      ),
      GoRoute(
        path: '/scheduled-delivery',
        builder: (context, state) => const ScheduledDeliveryScreen(),
      ),
      GoRoute(
        path: '/bulk-delivery',
        builder: (context, state) => const BulkDeliveryScreen(),
      ),
      GoRoute(
        path: '/interstate-delivery',
        builder: (context, state) => const InterstateDeliveryScreen(),
      ),
      GoRoute(
        path: '/wallet',
        name: 'wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/topup',
        name: 'topup',
        builder: (context, state) => const TopUpScreen(),
      ),
      GoRoute(
        path: '/transfer',
        name: 'transfer',
        builder: (context, state) => const TransferScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrdersListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) => _customTransition(
              state,
              OrderDetailsScreen(deliveryId: state.pathParameters['id']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => _customTransition(state, const ProfileScreen()),
        routes: [
          GoRoute(
            path: 'edit',
            pageBuilder: (context, state) => _customTransition(state, const EditProfileScreen()),
          ),
          GoRoute(
            path: 'settings',
            pageBuilder: (context, state) => _customTransition(state, const SettingsScreen()),
          ),
          GoRoute(
            path: 'addresses',
            builder: (context, state) => const AddressesScreen(),
          ),
          GoRoute(
            path: 'help',
            builder: (context, state) => const HelpSupportScreen(),
          ),
          GoRoute(
            path: 'payments',
            builder: (context, state) => const PaymentMethodsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/add-address',
        name: 'add-address',
        builder: (context, state) => const AddAddressScreen(),
      ),
      GoRoute(
        path: '/add-card',
        name: 'add-card',
        builder: (context, state) => const AddCardScreen(),
      ),
      GoRoute(
        path: '/chat',
        pageBuilder: (context, state) => _customTransition(state, const ChatScreen()),
      ),
    ],
    errorPageBuilder: (context, state) => _customTransition(state, ErrorScreen(error: state.error.toString())),
  );
});

CustomTransitionPage _customTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      );
    },
  );
}

class AuthListenable extends ChangeNotifier {
  AuthListenable(Ref ref) {
    _subscription = ref.listen(authNotifierProvider, (_, __) {
      notifyListeners();
    });
  }

  ProviderSubscription? _subscription;

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}
