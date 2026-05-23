import 'dart:math';

class PriceEstimator {
  static const double _baseFare = 500.0; // NGN
  static const double _perKmRate = 150.0;
  static const double _weightMultiplier = 50.0;

  /// Calculates estimated price based on distance (Haversine) and weight.
  static double estimate({
    required double pickupLat,
    required double pickupLng,
    required double dropoffLat,
    required double dropoffLng,
    double weightKg = 1.0,
  }) {
    final distanceKm = _haversineDistance(pickupLat, pickupLng, dropoffLat, dropoffLng);
    final distanceCost = distanceKm * _perKmRate;
    final weightCost = weightKg * _weightMultiplier;
    return _baseFare + distanceCost + weightCost;
  }

  /// Haversine formula to calculate distance between two lat/lng points in kilometers.
  static double _haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _toRadians(double degree) => degree * pi / 180;
}
