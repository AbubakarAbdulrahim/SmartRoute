// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TrackingModel _$TrackingModelFromJson(Map<String, dynamic> json) {
  return _TrackingModel.fromJson(json);
}

/// @nodoc
mixin _$TrackingModel {
  String get deliveryId => throw _privateConstructorUsedError;
  String get riderId => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get heading => throw _privateConstructorUsedError;
  double get speed => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this TrackingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrackingModelCopyWith<TrackingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrackingModelCopyWith<$Res> {
  factory $TrackingModelCopyWith(
    TrackingModel value,
    $Res Function(TrackingModel) then,
  ) = _$TrackingModelCopyWithImpl<$Res, TrackingModel>;
  @useResult
  $Res call({
    String deliveryId,
    String riderId,
    double latitude,
    double longitude,
    double heading,
    double speed,
    DateTime timestamp,
  });
}

/// @nodoc
class _$TrackingModelCopyWithImpl<$Res, $Val extends TrackingModel>
    implements $TrackingModelCopyWith<$Res> {
  _$TrackingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deliveryId = null,
    Object? riderId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? heading = null,
    Object? speed = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            deliveryId: null == deliveryId
                ? _value.deliveryId
                : deliveryId // ignore: cast_nullable_to_non_nullable
                      as String,
            riderId: null == riderId
                ? _value.riderId
                : riderId // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            heading: null == heading
                ? _value.heading
                : heading // ignore: cast_nullable_to_non_nullable
                      as double,
            speed: null == speed
                ? _value.speed
                : speed // ignore: cast_nullable_to_non_nullable
                      as double,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrackingModelImplCopyWith<$Res>
    implements $TrackingModelCopyWith<$Res> {
  factory _$$TrackingModelImplCopyWith(
    _$TrackingModelImpl value,
    $Res Function(_$TrackingModelImpl) then,
  ) = __$$TrackingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String deliveryId,
    String riderId,
    double latitude,
    double longitude,
    double heading,
    double speed,
    DateTime timestamp,
  });
}

/// @nodoc
class __$$TrackingModelImplCopyWithImpl<$Res>
    extends _$TrackingModelCopyWithImpl<$Res, _$TrackingModelImpl>
    implements _$$TrackingModelImplCopyWith<$Res> {
  __$$TrackingModelImplCopyWithImpl(
    _$TrackingModelImpl _value,
    $Res Function(_$TrackingModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deliveryId = null,
    Object? riderId = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? heading = null,
    Object? speed = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$TrackingModelImpl(
        deliveryId: null == deliveryId
            ? _value.deliveryId
            : deliveryId // ignore: cast_nullable_to_non_nullable
                  as String,
        riderId: null == riderId
            ? _value.riderId
            : riderId // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        heading: null == heading
            ? _value.heading
            : heading // ignore: cast_nullable_to_non_nullable
                  as double,
        speed: null == speed
            ? _value.speed
            : speed // ignore: cast_nullable_to_non_nullable
                  as double,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrackingModelImpl implements _TrackingModel {
  const _$TrackingModelImpl({
    required this.deliveryId,
    required this.riderId,
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.speed,
    required this.timestamp,
  });

  factory _$TrackingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrackingModelImplFromJson(json);

  @override
  final String deliveryId;
  @override
  final String riderId;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double heading;
  @override
  final double speed;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'TrackingModel(deliveryId: $deliveryId, riderId: $riderId, latitude: $latitude, longitude: $longitude, heading: $heading, speed: $speed, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrackingModelImpl &&
            (identical(other.deliveryId, deliveryId) ||
                other.deliveryId == deliveryId) &&
            (identical(other.riderId, riderId) || other.riderId == riderId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.heading, heading) || other.heading == heading) &&
            (identical(other.speed, speed) || other.speed == speed) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    deliveryId,
    riderId,
    latitude,
    longitude,
    heading,
    speed,
    timestamp,
  );

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrackingModelImplCopyWith<_$TrackingModelImpl> get copyWith =>
      __$$TrackingModelImplCopyWithImpl<_$TrackingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrackingModelImplToJson(this);
  }
}

abstract class _TrackingModel implements TrackingModel {
  const factory _TrackingModel({
    required final String deliveryId,
    required final String riderId,
    required final double latitude,
    required final double longitude,
    required final double heading,
    required final double speed,
    required final DateTime timestamp,
  }) = _$TrackingModelImpl;

  factory _TrackingModel.fromJson(Map<String, dynamic> json) =
      _$TrackingModelImpl.fromJson;

  @override
  String get deliveryId;
  @override
  String get riderId;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get heading;
  @override
  double get speed;
  @override
  DateTime get timestamp;

  /// Create a copy of TrackingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrackingModelImplCopyWith<_$TrackingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
