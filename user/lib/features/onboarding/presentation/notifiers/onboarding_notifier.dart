import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/local_storage_service.dart';

final onboardingNotifierProvider = NotifierProvider<OnboardingNotifier, bool>(() {
  return OnboardingNotifier();
});

class OnboardingNotifier extends Notifier<bool> {
  late final LocalStorageService _storage;

  @override
  bool build() {
    _storage = ref.watch(localStorageServiceProvider);
    return _storage.isOnboardingComplete();
  }

  Future<void> completeOnboarding() async {
    await _storage.setOnboardingComplete();
    state = true;
  }
}
