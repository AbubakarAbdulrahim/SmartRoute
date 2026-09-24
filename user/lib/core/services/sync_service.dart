import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_route/core/models/delivery_model.dart';
import 'connectivity_service.dart';
import 'firestore_service.dart';
// import '../shared/models/delivery_model.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return SyncService(firestore);
});

class SyncService {
  final FirestoreService _firestoreService;
  static const String _queueBoxName = 'offline_queue';

  SyncService(this._firestoreService);

  Future<void> init() async {
    await Hive.openBox(_queueBoxName);
  }

  Future<void> addToQueue(DeliveryModel delivery) async {
    final box = Hive.box(_queueBoxName);
    await box.add(jsonEncode(delivery.toJson()));
  }

  Future<void> syncPending() async {
    final isConnected = await ConnectivityService.isConnected();
    if (!isConnected) return;

    final box = Hive.box(_queueBoxName);
    if (box.isEmpty) return;

    print('Starting background sync: ${box.length} items found');

    final items = List.from(box.values);
    for (var i = 0; i < items.length; i++) {
      try {
        final deliveryJson = jsonDecode(items[i]);
        final delivery = DeliveryModel.fromJson(deliveryJson);
        
        await _firestoreService.createDelivery(delivery);
        await box.deleteAt(i);
        
        print('Successfully synced delivery ${delivery.deliveryId}');
      } catch (e) {
        print('Failed to sync item $i: $e');
      }
    }
  }

  bool get hasPendingItems => Hive.box(_queueBoxName).isNotEmpty;
}
