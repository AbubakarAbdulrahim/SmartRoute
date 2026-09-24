// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RiderModelImpl _$$RiderModelImplFromJson(Map<String, dynamic> json) =>
    _$RiderModelImpl(
      riderId: json['riderId'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      profileImage: json['profileImage'] as String?,
      vehicleType: json['vehicleType'] as String,
      vehicleColor: json['vehicleColor'] as String,
      plateNumber: json['plateNumber'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      completedDeliveries: (json['completedDeliveries'] as num?)?.toInt() ?? 0,
      acceptanceRate: (json['acceptanceRate'] as num?)?.toDouble() ?? 0.0,
      online: json['online'] as bool? ?? true,
      available: json['available'] as bool? ?? true,
      currentLat: (json['currentLat'] as num?)?.toDouble() ?? 0.0,
      currentLng: (json['currentLng'] as num?)?.toDouble() ?? 0.0,
      currentAddress: json['currentAddress'] as String?,
      estimatedArrivalMinutes:
          (json['estimatedArrivalMinutes'] as num?)?.toInt() ?? 0,
      reliabilityScore: (json['reliabilityScore'] as num?)?.toInt() ?? 0,
      lastSeen: json['lastSeen'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RiderModelImplToJson(_$RiderModelImpl instance) =>
    <String, dynamic>{
      'riderId': instance.riderId,
      'fullName': instance.fullName,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'profileImage': instance.profileImage,
      'vehicleType': instance.vehicleType,
      'vehicleColor': instance.vehicleColor,
      'plateNumber': instance.plateNumber,
      'rating': instance.rating,
      'completedDeliveries': instance.completedDeliveries,
      'acceptanceRate': instance.acceptanceRate,
      'online': instance.online,
      'available': instance.available,
      'currentLat': instance.currentLat,
      'currentLng': instance.currentLng,
      'currentAddress': instance.currentAddress,
      'estimatedArrivalMinutes': instance.estimatedArrivalMinutes,
      'reliabilityScore': instance.reliabilityScore,
      'lastSeen': instance.lastSeen,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
