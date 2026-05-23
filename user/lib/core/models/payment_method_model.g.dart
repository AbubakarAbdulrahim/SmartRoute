// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodModelImpl _$$PaymentMethodModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentMethodModelImpl(
  id: json['id'] as String,
  cardNumber: json['cardNumber'] as String,
  expiryDate: json['expiryDate'] as String,
  cardType: json['cardType'] as String,
  isDefault: json['isDefault'] as bool? ?? false,
);

Map<String, dynamic> _$$PaymentMethodModelImplToJson(
  _$PaymentMethodModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'cardNumber': instance.cardNumber,
  'expiryDate': instance.expiryDate,
  'cardType': instance.cardType,
  'isDefault': instance.isDefault,
};
