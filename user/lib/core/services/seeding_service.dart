import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../models/rider_model.dart';
import '../constants/app_constants.dart';

class SeedingService {
  static Future<void> seedRiders() async {
    final db = FirebaseFirestore.instance;
    final ridersCollection = db.collection(AppConstants.ridersCollection);
    
    final kanoLat = 12.0022;
    final kanoLng = 8.5920;
    
    final names = [
      'Abubakar Bello', 'Ibrahim Hassan', 'Fatima Musa', 'Zainab Dahiru', 
      'Usman Umar', 'Musa Garba', 'Aisha Yusuf', 'Aminu Lawal', 
      'Sani Abdullahi', 'Hadiza Idris'
    ];
    
    final vehicleTypes = ['Bike', 'Motorcycle', 'Motorcycle', 'Bike', 'Van', 'Motorcycle', 'Bike', 'Motorcycle', 'Van', 'Motorcycle'];
    final colors = ['Red', 'Black', 'Blue', 'White', 'Silver', 'Green', 'Yellow', 'Black', 'White', 'Red'];
    
    final random = Random();
    
    final batch = db.batch();
    
    for (int i = 0; i < names.length; i++) {
      final riderId = 'RIDER-${100 + i}';
      
      // Randomize lat/lng within ~5km of base
      final latOffset = (random.nextDouble() - 0.5) * 0.05;
      final lngOffset = (random.nextDouble() - 0.5) * 0.05;
      
      final rider = RiderModel(
        riderId: riderId,
        fullName: names[i],
        phoneNumber: '+23480${random.nextInt(10000000).toString().padLeft(7, '0')}',
        email: '${names[i].toLowerCase().replaceAll(' ', '.')}@smartroute.com',
        vehicleType: vehicleTypes[i],
        vehicleColor: colors[i],
        plateNumber: 'KAN-${random.nextInt(900)}AB',
        rating: 4.0 + (random.nextDouble() * 1.0),
        completedDeliveries: 50 + random.nextInt(200),
        acceptanceRate: 0.85 + (random.nextDouble() * 0.15),
        online: true,
        available: true,
        currentLat: kanoLat + latOffset,
        currentLng: kanoLng + lngOffset,
        currentAddress: 'Kano, Nigeria',
        estimatedArrivalMinutes: 3 + random.nextInt(12),
        reliabilityScore: 80 + random.nextInt(20),
        lastSeen: DateTime.now().toIso8601String(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      batch.set(ridersCollection.doc(riderId), rider.toJson());
    }
    
    await batch.commit();
    print('Successfully seeded 10 riders near Kano.');
  }
}
