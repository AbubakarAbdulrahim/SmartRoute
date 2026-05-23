// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrackingModelImpl _$$TrackingModelImplFromJson(Map<String, dynamic> json) =>
    _$TrackingModelImpl(
      deliveryId: json['deliveryId'] as String,
      riderId: json['riderId'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$TrackingModelImplToJson(_$TrackingModelImpl instance) =>
    <String, dynamic>{
      'deliveryId': instance.deliveryId,
      'riderId': instance.riderId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'heading': instance.heading,
      'speed': instance.speed,
      'timestamp': instance.timestamp.toIso8601String(),
    };
