import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/services/location_service.dart';

enum SOSStatus { idle, triggering, sending, sent, error }

class SOSState {
  final SOSStatus status;
  final String? errorMessage;

  SOSState({this.status = SOSStatus.idle, this.errorMessage});

  SOSState copyWith({SOSStatus? status, String? errorMessage}) {
    return SOSState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final sosNotifierProvider = StateNotifierProvider<SOSNotifier, SOSState>((ref) {
  return SOSNotifier(
    ref.read(firestoreServiceProvider),
    ref.read(locationServiceProvider),
  );
});

class SOSNotifier extends StateNotifier<SOSState> {
  final FirestoreService _firestoreService;
  final LocationService _locationService;

  SOSNotifier(this._firestoreService, this._locationService) : super(SOSState());

  void setTriggering() {
    state = state.copyWith(status: SOSStatus.triggering);
  }

  void reset() {
    state = state.copyWith(status: SOSStatus.idle);
  }

  Future<void> triggerAlert() async {
    state = state.copyWith(status: SOSStatus.sending);
    try {
      final position = await _locationService.getCurrentLocation();
      
      await _firestoreService.sendSOS(
        'current_user_id', // placeholder, usually from AuthService
        {
          'lat': position.latitude,
          'lng': position.longitude,
        },
      );
      
      state = state.copyWith(status: SOSStatus.sent);
    } catch (e) {
      state = state.copyWith(status: SOSStatus.error, errorMessage: e.toString());
    }
  }
}
