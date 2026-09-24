import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/models/delivery_model.dart';
import 'dart:io';

final deliveryNotifierProvider =
    NotifierProvider<DeliveryNotifier, DeliveryDraftState>(() {
  return DeliveryNotifier();
});

enum DeliveryStep { pickup, destination, details, summary, submitting, success, error }

class DeliveryDraftState {
  final DeliveryStep step;
  final LatLng? pickupLocation;
  final String? pickupAddress;
  final LatLng? destinationLocation;
  final String? destinationAddress;
  final String? packageDescription;
  final String? packageCategory;
  final double weightKg;
  final double estimatedPrice;
  final String? itemImagePath;
  final String? receiverName;
  final String? receiverPhone;
  final String? errorMessage;

  DeliveryDraftState({
    this.step = DeliveryStep.pickup,
    this.pickupLocation,
    this.pickupAddress,
    this.destinationLocation,
    this.destinationAddress,
    this.packageDescription,
    this.packageCategory,
    this.weightKg = 1.0,
    this.estimatedPrice = 0.0,
    this.itemImagePath,
    this.receiverName,
    this.receiverPhone,
    this.errorMessage,
  });

  DeliveryDraftState copyWith({
    DeliveryStep? step,
    LatLng? pickupLocation,
    String? pickupAddress,
    LatLng? destinationLocation,
    String? destinationAddress,
    String? packageDescription,
    String? packageCategory,
    double? weightKg,
    double? estimatedPrice,
    String? itemImagePath,
    String? receiverName,
    String? receiverPhone,
    String? errorMessage,
  }) {
    return DeliveryDraftState(
      step: step ?? this.step,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      destinationAddress: destinationAddress ?? this.destinationAddress,
      packageDescription: packageDescription ?? this.packageDescription,
      packageCategory: packageCategory ?? this.packageCategory,
      weightKg: weightKg ?? this.weightKg,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      itemImagePath: itemImagePath ?? this.itemImagePath,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DeliveryNotifier extends Notifier<DeliveryDraftState> {
  late final FirestoreService _firestoreService;

  @override
  DeliveryDraftState build() {
    _firestoreService = ref.watch(firestoreServiceProvider);
    return DeliveryDraftState();
  }

  Future<void> submitDelivery() async {
    state = state.copyWith(step: DeliveryStep.submitting);
    try {
      final deliveryId = "DEL-${DateTime.now().millisecondsSinceEpoch}";
      final otp = (1000 + Random().nextInt(9000)).toString();

      String? uploadedImageUrl = state.itemImagePath;
      if (state.itemImagePath != null && !state.itemImagePath!.startsWith('http')) {
        try {
          final storageService = ref.read(storageServiceProvider);
          uploadedImageUrl = await storageService.uploadFile(
            'deliveries/$deliveryId',
            File(state.itemImagePath!),
          );
        } catch (e) {
          debugPrint("Cloudinary Upload Error: $e");
          // Continue with local path or fail? Let's fail for data integrity
          throw "Failed to upload package image. Please check your connection.";
        }
      }

      final delivery = DeliveryModel(
        deliveryId: deliveryId,
        customerId: FirebaseAuth.instance.currentUser?.uid ?? 'guest',
        pickupAddress: state.pickupAddress ?? '',
        destinationAddress: state.destinationAddress ?? '',
        pickupLat: state.pickupLocation!.latitude,
        pickupLng: state.pickupLocation!.longitude,
        destinationLat: state.destinationLocation!.latitude,
        destinationLng: state.destinationLocation!.longitude,
        packageDescription: state.packageDescription,
        packageCategory: state.packageCategory ?? 'Express Delivery',
        packageImage: uploadedImageUrl,
        deliveryFee: state.estimatedPrice,
        status: DeliveryStatus.pending_acceptance,
        otpCode: otp,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        await _firestoreService.createDelivery(delivery);
        state = state.copyWith(step: DeliveryStep.success);
      } catch (e) {
        debugPrint("Firestore Save Error: $e");
        rethrow; // Let the outer catch handle it and show as error step
      }
    } catch (e) {
      state = state.copyWith(step: DeliveryStep.error, errorMessage: e.toString());
    }
  }

  void reset() {
    state = DeliveryDraftState();
  }

  void setPickup(LatLng location, String address) {
    state = state.copyWith(
      pickupLocation: location,
      pickupAddress: address,
      step: DeliveryStep.destination,
    );
  }

  void setDestination(LatLng location, String address) {
    state = state.copyWith(
      destinationLocation: location,
      destinationAddress: address,
      step: DeliveryStep.details,
    );
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    const double radius = 6371; // Earth's radius in KM
    double lat1 = p1.latitude * pi / 180;
    double lat2 = p2.latitude * pi / 180;
    double dLat = (p2.latitude - p1.latitude) * pi / 180;
    double dLng = (p2.longitude - p1.longitude) * pi / 180;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return radius * c;
  }

  void setPackageDetails({
    required String description,
    required double weight,
    String? category,
    String? imagePath,
    String? receiverName,
    String? receiverPhone,
  }) {
    double price = 1000; // Base Price
    if (state.pickupLocation != null && state.destinationLocation != null) {
      double km = _calculateDistance(state.pickupLocation!, state.destinationLocation!);
      price = (km * 100).clamp(1000, 50000); // 100 per KM, min 1000
    }

    state = state.copyWith(
      packageDescription: description,
      packageCategory: category ?? 'Standard Delivery',
      weightKg: weight,
      itemImagePath: imagePath,
      receiverName: receiverName,
      receiverPhone: receiverPhone,
      estimatedPrice: price,
      step: DeliveryStep.summary,
    );
  }
}
