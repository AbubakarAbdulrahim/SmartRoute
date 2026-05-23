// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeliveryModelImpl _$$DeliveryModelImplFromJson(Map<String, dynamic> json) =>
    _$DeliveryModelImpl(
      deliveryId: json['deliveryId'] as String,
      customerId: json['customerId'] as String,
      riderId: json['riderId'] as String?,
      pickupAddress: json['pickupAddress'] as String,
      destinationAddress: json['destinationAddress'] as String,
      pickupLat: (json['pickupLat'] as num).toDouble(),
      pickupLng: (json['pickupLng'] as num).toDouble(),
      destinationLat: (json['destinationLat'] as num).toDouble(),
      destinationLng: (json['destinationLng'] as num).toDouble(),
      packageDescription: json['packageDescription'] as String?,
      packageCategory: json['packageCategory'] as String?,
      packageImage: json['packageImage'] as String?,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      status: $enumDecode(_$DeliveryStatusEnumMap, json['status']),
      otpCode: json['otpCode'] as String?,
      aiMatched: json['aiMatched'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$DeliveryModelImplToJson(_$DeliveryModelImpl instance) =>
    <String, dynamic>{
      'deliveryId': instance.deliveryId,
      'customerId': instance.customerId,
      'riderId': instance.riderId,
      'pickupAddress': instance.pickupAddress,
      'destinationAddress': instance.destinationAddress,
      'pickupLat': instance.pickupLat,
      'pickupLng': instance.pickupLng,
      'destinationLat': instance.destinationLat,
      'destinationLng': instance.destinationLng,
      'packageDescription': instance.packageDescription,
      'packageCategory': instance.packageCategory,
      'packageImage': instance.packageImage,
      'deliveryFee': instance.deliveryFee,
      'status': _$DeliveryStatusEnumMap[instance.status]!,
      'otpCode': instance.otpCode,
      'aiMatched': instance.aiMatched,
      'createdAt': instance.createdAt?.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$DeliveryStatusEnumMap = {
  DeliveryStatus.pending: 'pending',
  DeliveryStatus.pending_acceptance: 'pending_acceptance',
  DeliveryStatus.ongoing: 'ongoing',
  DeliveryStatus.completed: 'completed',
  DeliveryStatus.cancelled: 'cancelled',
};
