import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/notification_model.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';

enum NotificationFilter { all, orders, offers }

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final NotificationFilter filter;

  NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.filter = NotificationFilter.all,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    NotificationFilter? filter,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      filter: filter ?? this.filter,
    );
  }

  List<NotificationModel> get filteredNotifications {
    if (filter == NotificationFilter.all) return notifications;
    final typeStr = filter == NotificationFilter.orders ? 'order' : 'offer';
    return notifications.where((n) => n.type.toLowerCase().contains(typeStr)).toList();
  }
}

final notificationNotifierProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return NotificationNotifier(ref.read(firestoreServiceProvider), authState);
});

class NotificationNotifier extends StateNotifier<NotificationState> {
  final FirestoreService _firestoreService;
  final AuthState _authState;
  StreamSubscription? _subscription;

  NotificationNotifier(this._firestoreService, this._authState) : super(NotificationState()) {
    _listenToNotifications();
  }

  void _listenToNotifications() {
    if (_authState.user == null) return;
    
    _subscription?.cancel();
    state = state.copyWith(isLoading: true);
    
    _subscription = _firestoreService.streamNotifications(_authState.user!.uid).listen((data) {
      final models = data.map((d) => NotificationModel.fromJson(d)).toList();
      state = state.copyWith(notifications: models, isLoading: false);
    });
  }

  void setFilter(NotificationFilter filter) {
    state = state.copyWith(filter: filter);
  }

  Future<void> markAsRead(String notificationId) async {
    if (_authState.user == null) return;
    await _firestoreService.updateNotificationReadStatus(_authState.user!.uid, notificationId, true);
  }

  Future<void> markAllAsRead() async {
    if (_authState.user == null) return;
    await _firestoreService.markAllNotificationsRead(_authState.user!.uid);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
