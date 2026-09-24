import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/router.dart';
import 'core/services/local_storage_service.dart';
import 'core/services/messaging_service.dart';
import 'core/services/sync_service.dart';
import 'core/theme/app_theme.dart';
import 'core/services/seeding_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final prefs = await SharedPreferences.getInstance();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await SeedingService.seedRiders();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
    runApp(FirebaseInitErrorApp(error: e));
    return;
  }

  final container = ProviderContainer();

  try {
    await container.read(messagingServiceProvider).init();
  } catch (e) {
    debugPrint('Messaging service initialization failed: $e');
  }

  var syncReady = false;
  try {
    await container.read(syncServiceProvider).init();
    syncReady = true;
  } catch (e) {
    debugPrint('Sync service initialization failed: $e');
  }

  if (syncReady) {
    unawaited(
      container.read(syncServiceProvider).syncPending().catchError((Object e) {
        debugPrint('Background sync failed: $e');
      }),
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(LocalStorageService(prefs)),
      ],
      child: const SmartRouteApp(),
    ),
  );
}

class FirebaseInitErrorApp extends StatelessWidget {
  const FirebaseInitErrorApp({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Firebase could not start.\n\n$error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class SmartRouteApp extends ConsumerWidget {
  const SmartRouteApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'SmartRoute AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
