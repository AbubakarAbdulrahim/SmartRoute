import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/delivery_model.dart';
import '../models/rider_model.dart';
import '../models/notification_model.dart';
import '../constants/app_constants.dart';
import 'base_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService(FirebaseFirestore.instance));

class FirestoreService extends BaseService {
  final FirebaseFirestore _db;
  FirestoreService(this._db);

  Future<UserModel?> getUser(String uid) async {
    return handleError(() async {
      final doc = await _db.collection(AppConstants.usersCollection).doc(uid).get();
      return doc.exists ? UserModel.fromJson(doc.data()!) : null;
    });
  }

  // User Operations
  Future<void> saveUser(UserModel user) async {
    return handleError(() async {
      await _db.collection(AppConstants.usersCollection).doc(user.uid).set(user.toJson());
    });
  }

  Stream<UserModel?> streamUser(String uid) {
    return handleStreamError(
      _db.collection(AppConstants.usersCollection).doc(uid).snapshots().map(
            (doc) => doc.exists ? UserModel.fromJson(doc.data()!) : null,
          ),
    );
  }

  // Delivery Operations
  Future<void> createDelivery(DeliveryModel delivery) async {
    return handleError(() async {
      await _db.collection(AppConstants.deliveriesCollection).doc(delivery.deliveryId).set(delivery.toJson());
    });
  }

  Stream<List<DeliveryModel>> streamUserDeliveries(String userId, {int limit = 50}) {
    return handleStreamError(
      _db
          .collection(AppConstants.deliveriesCollection)
          .where('customerId', isEqualTo: userId)
          // Removing orderBy to ensure documents without createdAt are not skipped
          .limit(limit)
          .snapshots()
          .map((snapshot) {
            final list = snapshot.docs.map((doc) => DeliveryModel.fromJson(doc.data())).toList();
            // Client-side sort fallback
            list.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
            return list;
          }),
    );
  }

  // Rider Operations
  Future<List<RiderModel>> getAvailableRiders() async {
    return handleError(() async {
      final snapshot = await _db
          .collection(AppConstants.ridersCollection)
          .where('online', isEqualTo: true)
          .where('available', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) => RiderModel.fromJson(doc.data())).toList();
    });
  }

  Future<void> createBookingRequest(DeliveryModel delivery) async {
    return handleError(() async {
      await _db.collection(AppConstants.deliveriesCollection).doc(delivery.deliveryId).set(delivery.toJson());
    });
  }

  Stream<DeliveryModel?> listenToBookingResponse(String deliveryId) {
    return handleStreamError(
      _db.collection(AppConstants.deliveriesCollection).doc(deliveryId).snapshots().map((doc) {
        if (!doc.exists) return null;
        return DeliveryModel.fromJson(doc.data()!);
      }),
    );
  }

  Stream<DeliveryModel?> watchDelivery(String id) {
    return handleStreamError(
      _db.collection(AppConstants.deliveriesCollection).doc(id).snapshots().map(
            (doc) => doc.exists ? DeliveryModel.fromJson(doc.data()!) : null,
          ),
    );
  }

  Future<bool> verifyDeliveryOTP(String id, String enteredOtp) async {
    return handleError(() async {
      final doc = await _db.collection(AppConstants.deliveriesCollection).doc(id).get();
      if (!doc.exists) return false;
      final delivery = DeliveryModel.fromJson(doc.data()!);
      return delivery.otpCode == enteredOtp;
    });
  }

  Future<void> updateDeliveryStatus(String id, DeliveryStatus status) async {
    return handleError(() async {
      await _db.collection(AppConstants.deliveriesCollection).doc(id).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Wallet Operations
  Future<void> updateUserBalance(String uid, double newBalance) async {
    return handleError(() async {
      await _db.collection(AppConstants.usersCollection).doc(uid).update({
        'balance': newBalance,
      });
    });
  }

  Future<void> saveTransaction(String uid, Map<String, dynamic> txData) async {
    return handleError(() async {
      await _db.collection(AppConstants.usersCollection).doc(uid).collection('transactions').add(txData);
    });
  }

  Stream<List<Map<String, dynamic>>> streamTransactions(String uid) {
    return handleStreamError(
      _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('transactions')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList()),
    );
  }

  // Address Operations
  Future<void> saveAddress(String uid, Map<String, dynamic> addressData) async {
    return handleError(() async {
      final id = addressData['id'] ?? _db.collection('temp').doc().id;
      await _db.collection(AppConstants.usersCollection).doc(uid).collection('addresses').doc(id).set({
        ...addressData,
        'id': id,
      });
    });
  }

  Stream<List<Map<String, dynamic>>> streamAddresses(String uid) {
    return handleStreamError(
      _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('addresses')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList()),
    );
  }

  // Payment Method Operations
  Future<void> savePaymentMethod(String uid, Map<String, dynamic> paymentData) async {
    return handleError(() async {
      final id = paymentData['id'] ?? _db.collection('temp').doc().id;
      await _db.collection(AppConstants.usersCollection).doc(uid).collection('payment_methods').doc(id).set({
        ...paymentData,
        'id': id,
      });
    });
  }

  Stream<List<Map<String, dynamic>>> streamPaymentMethods(String uid) {
    return handleStreamError(
      _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('payment_methods')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList()),
    );
  }

  // SOS & Emergency
  Future<void> sendSOS(String userId, Map<String, dynamic> location) async {
    return handleError(() async {
      await _db.collection('sos_alerts').add({
        'userId': userId,
        'location': location,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'active',
      });
    });
  }

  // Notification Operations
  Stream<List<Map<String, dynamic>>> streamNotifications(String uid) {
    return handleStreamError(
      _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList()),
    );
  }

  Future<void> createNotification(String uid, NotificationModel notification) async {
    return handleError(() async {
      await _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('notifications')
          .doc(notification.id)
          .set(notification.toJson());
    });
  }

  Future<void> updateNotificationReadStatus(String uid, String notificationId, bool isRead) async {
    return handleError(() async {
      await _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': isRead});
    });
  }

  Future<void> markAllNotificationsRead(String uid) async {
    return handleError(() async {
      final snapshot = await _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _db.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    });
  }

  // Tracking Operations
  Stream<Map<String, dynamic>> streamRiderLocation(String riderId) {
    return handleStreamError(
      _db.collection('tracking').doc(riderId).snapshots().map((doc) => doc.data() ?? {}),
    );
  }
}
