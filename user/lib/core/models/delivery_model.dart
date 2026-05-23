import 'package:freezed_annotation/freezed_annotation.dart';

part 'delivery_model.freezed.dart';
part 'delivery_model.g.dart';

enum DeliveryStatus {
  pending,
  pending_acceptance,
  ongoing,
  completed,
  cancelled
}

@freezed
class DeliveryModel with _$DeliveryModel {
  const factory DeliveryModel({
    required String deliveryId,
    required String customerId,
    String? riderId,
    required String pickupAddress,
    required String destinationAddress,
    required double pickupLat,
    required double pickupLng,
    required double destinationLat,
    required double destinationLng,
    String? packageDescription,
    String? packageCategory,
    String? packageImage,
    required double deliveryFee,
    required DeliveryStatus status,
    String? otpCode,
    @Default(true) bool aiMatched,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
    DateTime? updatedAt,
  }) = _DeliveryModel;

  factory DeliveryModel.fromJson(Map<String, dynamic> json)
      => _$DeliveryModelFromJson(json);
}
