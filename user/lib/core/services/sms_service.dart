import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final smsServiceProvider = Provider((ref) => SmsService());

class SmsService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  final String _baseUrl = kIsWeb ? 'http://localhost:3000' : 
                          (Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000');

  Future<bool> sendBookingSMS({
    required String phoneNumber,
    required String riderName,
    required String vehicleType,
    required int eta,
    required String deliveryId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/send-sms'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'riderName': riderName,
          'vehicleType': vehicleType,
          'eta': eta,
          'deliveryId': deliveryId,
        }),
      );

      if (kDebugMode) {
        print('SMS Proxy Result: ${response.statusCode} - ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error calling SMS proxy: $e');
      }
      return false;
    }
  }
}
