import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/models/delivery_model.dart';

final deliveryTrackingProvider = StreamProvider.family<DeliveryModel?, String>((ref, id) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.watchDelivery(id);
});

final riderLocationProvider = StreamProvider.family<Map<String, dynamic>, String>((ref, riderId) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.streamRiderLocation(riderId);
});

// For calculated tracking data (ETA, Polylines)
class TrackingDetails {
  final double etaMinutes;
  final double distanceKm;
  final String status;

  TrackingDetails({
    required this.etaMinutes,
    required this.distanceKm,
    required this.status,
  });
}

final trackingDetailsProvider = Provider.family<TrackingDetails, String>((ref, id) {
  final deliveryState = ref.watch(deliveryTrackingProvider(id));
  
  return deliveryState.when(
    data: (delivery) {
      if (delivery == null) return TrackingDetails(etaMinutes: 0, distanceKm: 0, status: 'Unknown');
      
      // Simple logic: distance / fixed speed + status
      // In production, this would be more complex or come from a service
      return TrackingDetails(
        etaMinutes: (delivery.deliveryFee / 100), // dummy logic
        distanceKm: (delivery.deliveryFee / 150), // dummy logic
        status: delivery.status.name.toUpperCase(),
      );
    },
    loading: () => TrackingDetails(etaMinutes: 0, distanceKm: 0, status: 'Loading...'),
    error: (_, __) => TrackingDetails(etaMinutes: 0, distanceKm: 0, status: 'Error'),
  );
});
