import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/rider_model.dart';
import '../../../../core/models/delivery_model.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../../core/models/notification_model.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import 'delivery_notifier.dart';

enum AiMatchingStep { idle, searching, ranking, results, booking, confirmed, error }

class AiMatchingState {
  final AiMatchingStep step;
  final List<RiderModel> allRiders;
  final List<RiderModel> rankedRiders;
  final RiderModel? selectedRider;
  final String? errorMessage;
  final String? deliveryId;

  AiMatchingState({
    this.step = AiMatchingStep.idle,
    this.allRiders = const [],
    this.rankedRiders = const [],
    this.selectedRider,
    this.errorMessage,
    this.deliveryId,
  });

  AiMatchingState copyWith({
    AiMatchingStep? step,
    List<RiderModel>? allRiders,
    List<RiderModel>? rankedRiders,
    RiderModel? selectedRider,
    String? errorMessage,
    String? deliveryId,
  }) {
    return AiMatchingState(
      step: step ?? this.step,
      allRiders: allRiders ?? this.allRiders,
      rankedRiders: rankedRiders ?? this.rankedRiders,
      selectedRider: selectedRider ?? this.selectedRider,
      errorMessage: errorMessage ?? this.errorMessage,
      deliveryId: deliveryId ?? this.deliveryId,
    );
  }
}

final aiMatchingNotifierProvider = StateNotifierProvider<AiMatchingNotifier, AiMatchingState>((ref) {
  return AiMatchingNotifier(
    ref.read(firestoreServiceProvider),
    ref.read(geminiServiceProvider),
    ref,
  );
});

class AiMatchingNotifier extends StateNotifier<AiMatchingState> {
  final FirestoreService _firestoreService;
  final GeminiService _geminiService;
  final Ref _ref;

  AiMatchingNotifier(this._firestoreService, this._geminiService, this._ref) : super(AiMatchingState());

  Future<void> findRiders() async {
    state = state.copyWith(step: AiMatchingStep.searching, errorMessage: null);

    try {
      // 1. Fetch available riders from Firestore
      final riders = await _firestoreService.getAvailableRiders();
      state = state.copyWith(allRiders: riders);

      if (riders.isEmpty) {
        state = state.copyWith(step: AiMatchingStep.error, errorMessage: "No active riders nearby");
        return;
      }

      // 2. Rank using Gemini
      state = state.copyWith(step: AiMatchingStep.ranking);
      
      final deliveryDraft = _ref.read(deliveryNotifierProvider);
      
      try {
        final rankedIds = await _geminiService.rankRiders(
          riders: riders,
          pickupAddress: deliveryDraft.pickupAddress ?? "Unknown",
          destinationAddress: deliveryDraft.destinationAddress ?? "Unknown",
        );

        if (rankedIds.isNotEmpty) {
          final rankedList = rankedIds.map((id) {
            for (final r in riders) {
              if (r.riderId == id) return r;
            }
            return riders.first;
          }).take(3).toList();
          state = state.copyWith(step: AiMatchingStep.results, rankedRiders: rankedList);
        } else {
          _useFallbackRanking(riders);
        }
      } catch (e) {
        _useFallbackRanking(riders);
      }
    } catch (e) {
      state = state.copyWith(step: AiMatchingStep.error, errorMessage: e.toString());
    }
  }

  void _useFallbackRanking(List<RiderModel> riders) {
    // Formula: rating (weight 0.7) + (1 / ETA) (weight 0.3)
    final sorted = List<RiderModel>.from(riders);
    sorted.sort((a, b) {
      final scoreA = (a.rating * 0.7) + ((1 / (a.estimatedArrivalMinutes + 1)) * 10);
      final scoreB = (b.rating * 0.7) + ((1 / (b.estimatedArrivalMinutes + 1)) * 10);
      return scoreB.compareTo(scoreA);
    });

    state = state.copyWith(
      step: AiMatchingStep.results,
      rankedRiders: sorted.take(3).toList(),
    );
  }

  void selectRider(RiderModel rider) {
    state = state.copyWith(selectedRider: rider);
  }

  Future<void> confirmBooking(String customerId) async {
    if (state.selectedRider == null) return;

    state = state.copyWith(step: AiMatchingStep.booking);

    final deliveryDraft = _ref.read(deliveryNotifierProvider);
    final deliveryId = "DEL-${DateTime.now().millisecondsSinceEpoch}";

    final delivery = DeliveryModel(
      deliveryId: deliveryId,
      customerId: customerId,
      riderId: state.selectedRider!.riderId,
      pickupAddress: deliveryDraft.pickupAddress ?? '',
      destinationAddress: deliveryDraft.destinationAddress ?? '',
      pickupLat: deliveryDraft.pickupLocation?.latitude ?? 0.0,
      pickupLng: deliveryDraft.pickupLocation?.longitude ?? 0.0,
      destinationLat: deliveryDraft.destinationLocation?.latitude ?? 0.0,
      destinationLng: deliveryDraft.destinationLocation?.longitude ?? 0.0,
      packageDescription: deliveryDraft.packageDescription,
      packageCategory: deliveryDraft.step == DeliveryStep.summary ? "Express" : "AI Logistics", // Fallback logic or refined
      packageImage: deliveryDraft.itemImagePath,
      deliveryFee: deliveryDraft.estimatedPrice,
      status: DeliveryStatus.pending_acceptance,
      otpCode: (1000 + (9000 * (Random.secure().nextDouble())).toInt()).toString(),
      aiMatched: true,
      createdAt: DateTime.now(),
    );

    try {
      await _firestoreService.createBookingRequest(delivery);
      
      // 2. Create notification for the user
      final notification = NotificationModel(
        id: "NOT-${DateTime.now().millisecondsSinceEpoch}",
        title: "Order Placed Successfully",
        body: "Your order $deliveryId has been placed. ${state.selectedRider!.fullName} is being notified.",
        type: "order",
        metadataId: deliveryId,
        createdAt: DateTime.now(),
      );
      await _firestoreService.createNotification(customerId, notification);

      state = state.copyWith(step: AiMatchingStep.confirmed, deliveryId: deliveryId);
    } catch (e) {
      state = state.copyWith(step: AiMatchingStep.error, errorMessage: e.toString());
    }
  }

  void reset() {
    state = AiMatchingState();
  }
}
