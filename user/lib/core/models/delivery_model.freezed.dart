// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DeliveryModel _$DeliveryModelFromJson(Map<String, dynamic> json) {
  return _DeliveryModel.fromJson(json);
}

/// @nodoc
mixin _$DeliveryModel {
  String get deliveryId => throw _privateConstructorUsedError;
  String get customerId => throw _privateConstructorUsedError;
  String? get riderId => throw _privateConstructorUsedError;
  String get pickupAddress => throw _privateConstructorUsedError;
  String get destinationAddress => throw _privateConstructorUsedError;
  double get pickupLat => throw _privateConstructorUsedError;
  double get pickupLng => throw _privateConstructorUsedError;
  double get destinationLat => throw _privateConstructorUsedError;
  double get destinationLng => throw _privateConstructorUsedError;
  String? get packageDescription => throw _privateConstructorUsedError;
  String? get packageCategory => throw _privateConstructorUsedError;
  String? get packageImage => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  DeliveryStatus get status => throw _privateConstructorUsedError;
  String? get otpCode => throw _privateConstructorUsedError;
  bool get aiMatched => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this DeliveryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryModelCopyWith<DeliveryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryModelCopyWith<$Res> {
  factory $DeliveryModelCopyWith(
    DeliveryModel value,
    $Res Function(DeliveryModel) then,
  ) = _$DeliveryModelCopyWithImpl<$Res, DeliveryModel>;
  @useResult
  $Res call({
    String deliveryId,
    String customerId,
    String? riderId,
    String pickupAddress,
    String destinationAddress,
    double pickupLat,
    double pickupLng,
    double destinationLat,
    double destinationLng,
    String? packageDescription,
    String? packageCategory,
    String? packageImage,
    double deliveryFee,
    DeliveryStatus status,
    String? otpCode,
    bool aiMatched,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$DeliveryModelCopyWithImpl<$Res, $Val extends DeliveryModel>
    implements $DeliveryModelCopyWith<$Res> {
  _$DeliveryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deliveryId = null,
    Object? customerId = null,
    Object? riderId = freezed,
    Object? pickupAddress = null,
    Object? destinationAddress = null,
    Object? pickupLat = null,
    Object? pickupLng = null,
    Object? destinationLat = null,
    Object? destinationLng = null,
    Object? packageDescription = freezed,
    Object? packageCategory = freezed,
    Object? packageImage = freezed,
    Object? deliveryFee = null,
    Object? status = null,
    Object? otpCode = freezed,
    Object? aiMatched = null,
    Object? createdAt = freezed,
    Object? acceptedAt = freezed,
    Object? completedAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            deliveryId: null == deliveryId
                ? _value.deliveryId
                : deliveryId // ignore: cast_nullable_to_non_nullable
                      as String,
            customerId: null == customerId
                ? _value.customerId
                : customerId // ignore: cast_nullable_to_non_nullable
                      as String,
            riderId: freezed == riderId
                ? _value.riderId
                : riderId // ignore: cast_nullable_to_non_nullable
                      as String?,
            pickupAddress: null == pickupAddress
                ? _value.pickupAddress
                : pickupAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            destinationAddress: null == destinationAddress
                ? _value.destinationAddress
                : destinationAddress // ignore: cast_nullable_to_non_nullable
                      as String,
            pickupLat: null == pickupLat
                ? _value.pickupLat
                : pickupLat // ignore: cast_nullable_to_non_nullable
                      as double,
            pickupLng: null == pickupLng
                ? _value.pickupLng
                : pickupLng // ignore: cast_nullable_to_non_nullable
                      as double,
            destinationLat: null == destinationLat
                ? _value.destinationLat
                : destinationLat // ignore: cast_nullable_to_non_nullable
                      as double,
            destinationLng: null == destinationLng
                ? _value.destinationLng
                : destinationLng // ignore: cast_nullable_to_non_nullable
                      as double,
            packageDescription: freezed == packageDescription
                ? _value.packageDescription
                : packageDescription // ignore: cast_nullable_to_non_nullable
                      as String?,
            packageCategory: freezed == packageCategory
                ? _value.packageCategory
                : packageCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            packageImage: freezed == packageImage
                ? _value.packageImage
                : packageImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            deliveryFee: null == deliveryFee
                ? _value.deliveryFee
                : deliveryFee // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as DeliveryStatus,
            otpCode: freezed == otpCode
                ? _value.otpCode
                : otpCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            aiMatched: null == aiMatched
                ? _value.aiMatched
                : aiMatched // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            acceptedAt: freezed == acceptedAt
                ? _value.acceptedAt
                : acceptedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeliveryModelImplCopyWith<$Res>
    implements $DeliveryModelCopyWith<$Res> {
  factory _$$DeliveryModelImplCopyWith(
    _$DeliveryModelImpl value,
    $Res Function(_$DeliveryModelImpl) then,
  ) = __$$DeliveryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String deliveryId,
    String customerId,
    String? riderId,
    String pickupAddress,
    String destinationAddress,
    double pickupLat,
    double pickupLng,
    double destinationLat,
    double destinationLng,
    String? packageDescription,
    String? packageCategory,
    String? packageImage,
    double deliveryFee,
    DeliveryStatus status,
    String? otpCode,
    bool aiMatched,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$DeliveryModelImplCopyWithImpl<$Res>
    extends _$DeliveryModelCopyWithImpl<$Res, _$DeliveryModelImpl>
    implements _$$DeliveryModelImplCopyWith<$Res> {
  __$$DeliveryModelImplCopyWithImpl(
    _$DeliveryModelImpl _value,
    $Res Function(_$DeliveryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deliveryId = null,
    Object? customerId = null,
    Object? riderId = freezed,
    Object? pickupAddress = null,
    Object? destinationAddress = null,
    Object? pickupLat = null,
    Object? pickupLng = null,
    Object? destinationLat = null,
    Object? destinationLng = null,
    Object? packageDescription = freezed,
    Object? packageCategory = freezed,
    Object? packageImage = freezed,
    Object? deliveryFee = null,
    Object? status = null,
    Object? otpCode = freezed,
    Object? aiMatched = null,
    Object? createdAt = freezed,
    Object? acceptedAt = freezed,
    Object? completedAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$DeliveryModelImpl(
        deliveryId: null == deliveryId
            ? _value.deliveryId
            : deliveryId // ignore: cast_nullable_to_non_nullable
                  as String,
        customerId: null == customerId
            ? _value.customerId
            : customerId // ignore: cast_nullable_to_non_nullable
                  as String,
        riderId: freezed == riderId
            ? _value.riderId
            : riderId // ignore: cast_nullable_to_non_nullable
                  as String?,
        pickupAddress: null == pickupAddress
            ? _value.pickupAddress
            : pickupAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        destinationAddress: null == destinationAddress
            ? _value.destinationAddress
            : destinationAddress // ignore: cast_nullable_to_non_nullable
                  as String,
        pickupLat: null == pickupLat
            ? _value.pickupLat
            : pickupLat // ignore: cast_nullable_to_non_nullable
                  as double,
        pickupLng: null == pickupLng
            ? _value.pickupLng
            : pickupLng // ignore: cast_nullable_to_non_nullable
                  as double,
        destinationLat: null == destinationLat
            ? _value.destinationLat
            : destinationLat // ignore: cast_nullable_to_non_nullable
                  as double,
        destinationLng: null == destinationLng
            ? _value.destinationLng
            : destinationLng // ignore: cast_nullable_to_non_nullable
                  as double,
        packageDescription: freezed == packageDescription
            ? _value.packageDescription
            : packageDescription // ignore: cast_nullable_to_non_nullable
                  as String?,
        packageCategory: freezed == packageCategory
            ? _value.packageCategory
            : packageCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        packageImage: freezed == packageImage
            ? _value.packageImage
            : packageImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        deliveryFee: null == deliveryFee
            ? _value.deliveryFee
            : deliveryFee // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as DeliveryStatus,
        otpCode: freezed == otpCode
            ? _value.otpCode
            : otpCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        aiMatched: null == aiMatched
            ? _value.aiMatched
            : aiMatched // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        acceptedAt: freezed == acceptedAt
            ? _value.acceptedAt
            : acceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryModelImpl implements _DeliveryModel {
  const _$DeliveryModelImpl({
    required this.deliveryId,
    required this.customerId,
    this.riderId,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.destinationLat,
    required this.destinationLng,
    this.packageDescription,
    this.packageCategory,
    this.packageImage,
    required this.deliveryFee,
    required this.status,
    this.otpCode,
    this.aiMatched = true,
    this.createdAt,
    this.acceptedAt,
    this.completedAt,
    this.updatedAt,
  });

  factory _$DeliveryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryModelImplFromJson(json);

  @override
  final String deliveryId;
  @override
  final String customerId;
  @override
  final String? riderId;
  @override
  final String pickupAddress;
  @override
  final String destinationAddress;
  @override
  final double pickupLat;
  @override
  final double pickupLng;
  @override
  final double destinationLat;
  @override
  final double destinationLng;
  @override
  final String? packageDescription;
  @override
  final String? packageCategory;
  @override
  final String? packageImage;
  @override
  final double deliveryFee;
  @override
  final DeliveryStatus status;
  @override
  final String? otpCode;
  @override
  @JsonKey()
  final bool aiMatched;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? acceptedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'DeliveryModel(deliveryId: $deliveryId, customerId: $customerId, riderId: $riderId, pickupAddress: $pickupAddress, destinationAddress: $destinationAddress, pickupLat: $pickupLat, pickupLng: $pickupLng, destinationLat: $destinationLat, destinationLng: $destinationLng, packageDescription: $packageDescription, packageCategory: $packageCategory, packageImage: $packageImage, deliveryFee: $deliveryFee, status: $status, otpCode: $otpCode, aiMatched: $aiMatched, createdAt: $createdAt, acceptedAt: $acceptedAt, completedAt: $completedAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryModelImpl &&
            (identical(other.deliveryId, deliveryId) ||
                other.deliveryId == deliveryId) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.riderId, riderId) || other.riderId == riderId) &&
            (identical(other.pickupAddress, pickupAddress) ||
                other.pickupAddress == pickupAddress) &&
            (identical(other.destinationAddress, destinationAddress) ||
                other.destinationAddress == destinationAddress) &&
            (identical(other.pickupLat, pickupLat) ||
                other.pickupLat == pickupLat) &&
            (identical(other.pickupLng, pickupLng) ||
                other.pickupLng == pickupLng) &&
            (identical(other.destinationLat, destinationLat) ||
                other.destinationLat == destinationLat) &&
            (identical(other.destinationLng, destinationLng) ||
                other.destinationLng == destinationLng) &&
            (identical(other.packageDescription, packageDescription) ||
                other.packageDescription == packageDescription) &&
            (identical(other.packageCategory, packageCategory) ||
                other.packageCategory == packageCategory) &&
            (identical(other.packageImage, packageImage) ||
                other.packageImage == packageImage) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.otpCode, otpCode) || other.otpCode == otpCode) &&
            (identical(other.aiMatched, aiMatched) ||
                other.aiMatched == aiMatched) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    deliveryId,
    customerId,
    riderId,
    pickupAddress,
    destinationAddress,
    pickupLat,
    pickupLng,
    destinationLat,
    destinationLng,
    packageDescription,
    packageCategory,
    packageImage,
    deliveryFee,
    status,
    otpCode,
    aiMatched,
    createdAt,
    acceptedAt,
    completedAt,
    updatedAt,
  ]);

  /// Create a copy of DeliveryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryModelImplCopyWith<_$DeliveryModelImpl> get copyWith =>
      __$$DeliveryModelImplCopyWithImpl<_$DeliveryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryModelImplToJson(this);
  }
}

abstract class _DeliveryModel implements DeliveryModel {
  const factory _DeliveryModel({
    required final String deliveryId,
    required final String customerId,
    final String? riderId,
    required final String pickupAddress,
    required final String destinationAddress,
    required final double pickupLat,
    required final double pickupLng,
    required final double destinationLat,
    required final double destinationLng,
    final String? packageDescription,
    final String? packageCategory,
    final String? packageImage,
    required final double deliveryFee,
    required final DeliveryStatus status,
    final String? otpCode,
    final bool aiMatched,
    final DateTime? createdAt,
    final DateTime? acceptedAt,
    final DateTime? completedAt,
    final DateTime? updatedAt,
  }) = _$DeliveryModelImpl;

  factory _DeliveryModel.fromJson(Map<String, dynamic> json) =
      _$DeliveryModelImpl.fromJson;

  @override
  String get deliveryId;
  @override
  String get customerId;
  @override
  String? get riderId;
  @override
  String get pickupAddress;
  @override
  String get destinationAddress;
  @override
  double get pickupLat;
  @override
  double get pickupLng;
  @override
  double get destinationLat;
  @override
  double get destinationLng;
  @override
  String? get packageDescription;
  @override
  String? get packageCategory;
  @override
  String? get packageImage;
  @override
  double get deliveryFee;
  @override
  DeliveryStatus get status;
  @override
  String? get otpCode;
  @override
  bool get aiMatched;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get acceptedAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of DeliveryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryModelImplCopyWith<_$DeliveryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
