import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/rider_model.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) => GeminiService());

class GeminiService {
  // IMPORTANT: For production, move this to a secure proxy/cloud function
  // Do NOT expose the API key in the frontend.
  static const _apiKey = 'AIzaSyCVJVgDedG7ryn73DiYAr_DjTaRUPxIsug';
  
  final GenerativeModel _model;

  GeminiService() : _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
  );

  Future<List<String>> rankRiders({
    required List<RiderModel> riders,
    required String pickupAddress,
    required String destinationAddress,
  }) async {
    if (riders.isEmpty) return [];

    final ridersData = riders.map((r) => {
      'riderId': r.riderId,
      'fullName': r.fullName,
      'rating': r.rating,
      'acceptanceRate': r.acceptanceRate,
      'completedDeliveries': r.completedDeliveries,
      'eta': r.estimatedArrivalMinutes,
      'vehicleType': r.vehicleType,
    }).toList();

    final prompt = '''
    You are a logistics intelligence AI for SmartRoute.
    Rank the following riders for this delivery from best to worst.

    Pickup Location: $pickupAddress
    Destination: $destinationAddress

    Riders Data:
    ${jsonEncode(ridersData)}

    Prioritize:
    - shortest ETA
    - best ratings (4.0+)
    - highest reliability (acceptance rate > 90%)
    - active availability

    Return ONLY a JSON list of rider IDs in ranked order.
    Example: ["rider1", "rider2", "rider3"]
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      
      final text = response.text;
      if (text == null) return [];

      // Extract JSON from response if AI provides extra text
      final jsonMatch = RegExp(r'\[.*\]').stringMatch(text);
      if (jsonMatch != null) {
        final List<dynamic> rankedIds = jsonDecode(jsonMatch);
        return rankedIds.cast<String>();
      }
      
      return [];
    } catch (e) {
      print('Gemini Error: $e');
      rethrow;
    }
  }
}
