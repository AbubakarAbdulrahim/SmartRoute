import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final userLocationProvider = Provider((ref) => null);

class LocationService {
  Future<bool> handlePermission() async {
    return true;
  }
}
