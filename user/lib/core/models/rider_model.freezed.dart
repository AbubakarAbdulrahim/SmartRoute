// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rider_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RiderModel _$RiderModelFromJson(Map<String, dynamic> json) {
  return _RiderModel.fromJson(json);
}

/// @nodoc
mixin _$RiderModel {
  String get riderId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get profileImage => throw _privateConstructorUsedError;
  String get vehicleType => throw _privateConstructorUsedError;
  String get vehicleColor => throw _privateConstructorUsedError;
  String get plateNumber => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get completedDeliveries => throw _privateConstructorUsedError;
  double get acceptanceRate => throw _privateConstructorUsedError;
  bool get online => throw _privateConstructorUsedError;
  bool get available => throw _privateConstructorUsedError;
  double get currentLat => throw _privateConstructorUsedError;
  double get currentLng => throw _privateConstructorUsedError;
  String? get currentAddress => throw _privateConstructorUsedError;
  int get estimatedArrivalMinutes => throw _privateConstructorUsedError;
  int get reliabilityScore => throw _privateConstructorUsedError;
  String? get lastSeen => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this RiderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RiderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RiderModelCopyWith<RiderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RiderModelCopyWith<$Res> {
  factory $RiderModelCopyWith(
    RiderModel value,
    $Res Function(RiderModel) then,
  ) = _$RiderModelCopyWithImpl<$Res, RiderModel>;
  @useResult
  $Res call({
    String riderId,
    String fullName,
    String phoneNumber,
    String email,
    String? profileImage,
    String vehicleType,
    String vehicleColor,
    String plateNumber,
    double rating,
    int completedDeliveries,
    double acceptanceRate,
    bool online,
    bool available,
    double currentLat,
    double currentLng,
    String? currentAddress,
    int estimatedArrivalMinutes,
    int reliabilityScore,
    String? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$RiderModelCopyWithImpl<$Res, $Val extends RiderModel>
    implements $RiderModelCopyWith<$Res> {
  _$RiderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RiderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riderId = null,
    Object? fullName = null,
    Object? phoneNumber = null,
    Object? email = null,
    Object? profileImage = freezed,
    Object? vehicleType = null,
    Object? vehicleColor = null,
    Object? plateNumber = null,
    Object? rating = null,
    Object? completedDeliveries = null,
    Object? acceptanceRate = null,
    Object? online = null,
    Object? available = null,
    Object? currentLat = null,
    Object? currentLng = null,
    Object? currentAddress = freezed,
    Object? estimatedArrivalMinutes = null,
    Object? reliabilityScore = null,
    Object? lastSeen = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            riderId: null == riderId
                ? _value.riderId
                : riderId // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phoneNumber: null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            profileImage: freezed == profileImage
                ? _value.profileImage
                : profileImage // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleType: null == vehicleType
                ? _value.vehicleType
                : vehicleType // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleColor: null == vehicleColor
                ? _value.vehicleColor
                : vehicleColor // ignore: cast_nullable_to_non_nullable
                      as String,
            plateNumber: null == plateNumber
                ? _value.plateNumber
                : plateNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            completedDeliveries: null == completedDeliveries
                ? _value.completedDeliveries
                : completedDeliveries // ignore: cast_nullable_to_non_nullable
                      as int,
            acceptanceRate: null == acceptanceRate
                ? _value.acceptanceRate
                : acceptanceRate // ignore: cast_nullable_to_non_nullable
                      as double,
            online: null == online
                ? _value.online
                : online // ignore: cast_nullable_to_non_nullable
                      as bool,
            available: null == available
                ? _value.available
                : available // ignore: cast_nullable_to_non_nullable
                      as bool,
            currentLat: null == currentLat
                ? _value.currentLat
                : currentLat // ignore: cast_nullable_to_non_nullable
                      as double,
            currentLng: null == currentLng
                ? _value.currentLng
                : currentLng // ignore: cast_nullable_to_non_nullable
                      as double,
            currentAddress: freezed == currentAddress
                ? _value.currentAddress
                : currentAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedArrivalMinutes: null == estimatedArrivalMinutes
                ? _value.estimatedArrivalMinutes
                : estimatedArrivalMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            reliabilityScore: null == reliabilityScore
                ? _value.reliabilityScore
                : reliabilityScore // ignore: cast_nullable_to_non_nullable
                      as int,
            lastSeen: freezed == lastSeen
                ? _value.lastSeen
                : lastSeen // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$RiderModelImplCopyWith<$Res>
    implements $RiderModelCopyWith<$Res> {
  factory _$$RiderModelImplCopyWith(
    _$RiderModelImpl value,
    $Res Function(_$RiderModelImpl) then,
  ) = __$$RiderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String riderId,
    String fullName,
    String phoneNumber,
    String email,
    String? profileImage,
    String vehicleType,
    String vehicleColor,
    String plateNumber,
    double rating,
    int completedDeliveries,
    double acceptanceRate,
    bool online,
    bool available,
    double currentLat,
    double currentLng,
    String? currentAddress,
    int estimatedArrivalMinutes,
    int reliabilityScore,
    String? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$RiderModelImplCopyWithImpl<$Res>
    extends _$RiderModelCopyWithImpl<$Res, _$RiderModelImpl>
    implements _$$RiderModelImplCopyWith<$Res> {
  __$$RiderModelImplCopyWithImpl(
    _$RiderModelImpl _value,
    $Res Function(_$RiderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RiderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riderId = null,
    Object? fullName = null,
    Object? phoneNumber = null,
    Object? email = null,
    Object? profileImage = freezed,
    Object? vehicleType = null,
    Object? vehicleColor = null,
    Object? plateNumber = null,
    Object? rating = null,
    Object? completedDeliveries = null,
    Object? acceptanceRate = null,
    Object? online = null,
    Object? available = null,
    Object? currentLat = null,
    Object? currentLng = null,
    Object? currentAddress = freezed,
    Object? estimatedArrivalMinutes = null,
    Object? reliabilityScore = null,
    Object? lastSeen = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$RiderModelImpl(
        riderId: null == riderId
            ? _value.riderId
            : riderId // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phoneNumber: null == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        profileImage: freezed == profileImage
            ? _value.profileImage
            : profileImage // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleType: null == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleColor: null == vehicleColor
            ? _value.vehicleColor
            : vehicleColor // ignore: cast_nullable_to_non_nullable
                  as String,
        plateNumber: null == plateNumber
            ? _value.plateNumber
            : plateNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        completedDeliveries: null == completedDeliveries
            ? _value.completedDeliveries
            : completedDeliveries // ignore: cast_nullable_to_non_nullable
                  as int,
        acceptanceRate: null == acceptanceRate
            ? _value.acceptanceRate
            : acceptanceRate // ignore: cast_nullable_to_non_nullable
                  as double,
        online: null == online
            ? _value.online
            : online // ignore: cast_nullable_to_non_nullable
                  as bool,
        available: null == available
            ? _value.available
            : available // ignore: cast_nullable_to_non_nullable
                  as bool,
        currentLat: null == currentLat
            ? _value.currentLat
            : currentLat // ignore: cast_nullable_to_non_nullable
                  as double,
        currentLng: null == currentLng
            ? _value.currentLng
            : currentLng // ignore: cast_nullable_to_non_nullable
                  as double,
        currentAddress: freezed == currentAddress
            ? _value.currentAddress
            : currentAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedArrivalMinutes: null == estimatedArrivalMinutes
            ? _value.estimatedArrivalMinutes
            : estimatedArrivalMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        reliabilityScore: null == reliabilityScore
            ? _value.reliabilityScore
            : reliabilityScore // ignore: cast_nullable_to_non_nullable
                  as int,
        lastSeen: freezed == lastSeen
            ? _value.lastSeen
            : lastSeen // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
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
class _$RiderModelImpl implements _RiderModel {
  const _$RiderModelImpl({
    required this.riderId,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.profileImage,
    required this.vehicleType,
    required this.vehicleColor,
    required this.plateNumber,
    this.rating = 0.0,
    this.completedDeliveries = 0,
    this.acceptanceRate = 0.0,
    this.online = true,
    this.available = true,
    this.currentLat = 0.0,
    this.currentLng = 0.0,
    this.currentAddress,
    this.estimatedArrivalMinutes = 0,
    this.reliabilityScore = 0,
    this.lastSeen,
    this.createdAt,
    this.updatedAt,
  });

  factory _$RiderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RiderModelImplFromJson(json);

  @override
  final String riderId;
  @override
  final String fullName;
  @override
  final String phoneNumber;
  @override
  final String email;
  @override
  final String? profileImage;
  @override
  final String vehicleType;
  @override
  final String vehicleColor;
  @override
  final String plateNumber;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int completedDeliveries;
  @override
  @JsonKey()
  final double acceptanceRate;
  @override
  @JsonKey()
  final bool online;
  @override
  @JsonKey()
  final bool available;
  @override
  @JsonKey()
  final double currentLat;
  @override
  @JsonKey()
  final double currentLng;
  @override
  final String? currentAddress;
  @override
  @JsonKey()
  final int estimatedArrivalMinutes;
  @override
  @JsonKey()
  final int reliabilityScore;
  @override
  final String? lastSeen;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'RiderModel(riderId: $riderId, fullName: $fullName, phoneNumber: $phoneNumber, email: $email, profileImage: $profileImage, vehicleType: $vehicleType, vehicleColor: $vehicleColor, plateNumber: $plateNumber, rating: $rating, completedDeliveries: $completedDeliveries, acceptanceRate: $acceptanceRate, online: $online, available: $available, currentLat: $currentLat, currentLng: $currentLng, currentAddress: $currentAddress, estimatedArrivalMinutes: $estimatedArrivalMinutes, reliabilityScore: $reliabilityScore, lastSeen: $lastSeen, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RiderModelImpl &&
            (identical(other.riderId, riderId) || other.riderId == riderId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profileImage, profileImage) ||
                other.profileImage == profileImage) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.vehicleColor, vehicleColor) ||
                other.vehicleColor == vehicleColor) &&
            (identical(other.plateNumber, plateNumber) ||
                other.plateNumber == plateNumber) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.completedDeliveries, completedDeliveries) ||
                other.completedDeliveries == completedDeliveries) &&
            (identical(other.acceptanceRate, acceptanceRate) ||
                other.acceptanceRate == acceptanceRate) &&
            (identical(other.online, online) || other.online == online) &&
            (identical(other.available, available) ||
                other.available == available) &&
            (identical(other.currentLat, currentLat) ||
                other.currentLat == currentLat) &&
            (identical(other.currentLng, currentLng) ||
                other.currentLng == currentLng) &&
            (identical(other.currentAddress, currentAddress) ||
                other.currentAddress == currentAddress) &&
            (identical(
                  other.estimatedArrivalMinutes,
                  estimatedArrivalMinutes,
                ) ||
                other.estimatedArrivalMinutes == estimatedArrivalMinutes) &&
            (identical(other.reliabilityScore, reliabilityScore) ||
                other.reliabilityScore == reliabilityScore) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    riderId,
    fullName,
    phoneNumber,
    email,
    profileImage,
    vehicleType,
    vehicleColor,
    plateNumber,
    rating,
    completedDeliveries,
    acceptanceRate,
    online,
    available,
    currentLat,
    currentLng,
    currentAddress,
    estimatedArrivalMinutes,
    reliabilityScore,
    lastSeen,
    createdAt,
    updatedAt,
  ]);

  /// Create a copy of RiderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RiderModelImplCopyWith<_$RiderModelImpl> get copyWith =>
      __$$RiderModelImplCopyWithImpl<_$RiderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RiderModelImplToJson(this);
  }
}

abstract class _RiderModel implements RiderModel {
  const factory _RiderModel({
    required final String riderId,
    required final String fullName,
    required final String phoneNumber,
    required final String email,
    final String? profileImage,
    required final String vehicleType,
    required final String vehicleColor,
    required final String plateNumber,
    final double rating,
    final int completedDeliveries,
    final double acceptanceRate,
    final bool online,
    final bool available,
    final double currentLat,
    final double currentLng,
    final String? currentAddress,
    final int estimatedArrivalMinutes,
    final int reliabilityScore,
    final String? lastSeen,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$RiderModelImpl;

  factory _RiderModel.fromJson(Map<String, dynamic> json) =
      _$RiderModelImpl.fromJson;

  @override
  String get riderId;
  @override
  String get fullName;
  @override
  String get phoneNumber;
  @override
  String get email;
  @override
  String? get profileImage;
  @override
  String get vehicleType;
  @override
  String get vehicleColor;
  @override
  String get plateNumber;
  @override
  double get rating;
  @override
  int get completedDeliveries;
  @override
  double get acceptanceRate;
  @override
  bool get online;
  @override
  bool get available;
  @override
  double get currentLat;
  @override
  double get currentLng;
  @override
  String? get currentAddress;
  @override
  int get estimatedArrivalMinutes;
  @override
  int get reliabilityScore;
  @override
  String? get lastSeen;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of RiderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RiderModelImplCopyWith<_$RiderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
