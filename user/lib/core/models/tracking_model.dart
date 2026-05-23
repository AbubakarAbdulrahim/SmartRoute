import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracking_model.freezed.dart';
part 'tracking_model.g.dart';

@freezed
class TrackingModel with _$TrackingModel {
  const factory TrackingModel({
    required String deliveryId,
    required String riderId,
    required double latitude,
    required double longitude,
    required double heading,
    required double speed,
    required DateTime timestamp,
  }) = _TrackingModel;

  factory TrackingModel.fromJson(Map<String, dynamic> json) => _$TrackingModelFromJson(json);
}
