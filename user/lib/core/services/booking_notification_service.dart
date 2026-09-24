import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'sms_service.dart';

final bookingNotificationServiceProvider = Provider((ref) {
  return BookingNotificationService(ref.read(smsServiceProvider));
});

class BookingNotificationService {
  final SmsService _smsService;

  BookingNotificationService(this._smsService);

  /// Normalizes phone number (e.g., 080... to +23480...)
  String _normalizePhoneNumber(String phoneNumber) {
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Nigeria handling
    if (cleaned.startsWith('0') && cleaned.length == 11) {
      return '+234${cleaned.substring(1)}';
    }
    
    if (cleaned.startsWith('234') && cleaned.length == 13) {
      return '+$cleaned';
    }
    
    if (cleaned.length == 10) {
      return '+234$cleaned';
    }

    if (!cleaned.startsWith('+')) {
      // Default to adding + if missing, assuming it's already in international format
      // but without the + sign.
      return '+$cleaned';
    }

    return phoneNumber;
  }

  Future<void> sendBookingSMS({
    required String phoneNumber,
    required String riderName,
    required String vehicleType,
    required int eta,
    required String deliveryId,
  }) async {
    final normalizedNumber = _normalizePhoneNumber(phoneNumber);
    
    await _smsService.sendBookingSMS(
      phoneNumber: normalizedNumber,
      riderName: riderName,
      vehicleType: vehicleType,
      eta: eta,
      deliveryId: deliveryId,
    );
  }
}
