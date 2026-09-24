import 'package:freezed_annotation/freezed_annotation.dart';

part 'rider_model.freezed.dart';
part 'rider_model.g.dart';

@freezed
class RiderModel with _$RiderModel {
  const factory RiderModel({
    required String riderId,
    required String fullName,
    required String phoneNumber,
    required String email,
    String? profileImage,
    required String vehicleType,
    required String vehicleColor,
    required String plateNumber,
    @Default(0.0) double rating,
    @Default(0) int completedDeliveries,
    @Default(0.0) double acceptanceRate,
    @Default(true) bool online,
    @Default(true) bool available,
    @Default(0.0) double currentLat,
    @Default(0.0) double currentLng,
    String? currentAddress,
    @Default(0) int estimatedArrivalMinutes,
    @Default(0) int reliabilityScore,
    String? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _RiderModel;

  factory RiderModel.fromJson(Map<String, dynamic> json) => _$RiderModelFromJson(json);
}
