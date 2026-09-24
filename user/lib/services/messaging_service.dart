import 'package:flutter_riverpod/flutter_riverpod.dart';

final messagingServiceProvider =
    Provider<MessagingService>((ref) {
  return MessagingService();
});

class MessagingService {
  Future<void> init() async {}
}
