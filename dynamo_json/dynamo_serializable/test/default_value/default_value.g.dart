// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: lines_longer_than_80_chars, text_direction_code_point_in_literal

part of 'default_value.dart';

// **************************************************************************
// DynamoSerializableGenerator
// **************************************************************************

DefaultValue _$DefaultValueFromDynamoJson(Map<String, dynamic> json) =>
    DefaultValue(
      json['fieldBool'] as bool? ?? true,
      json['fieldString'] as String? ?? 'string',
      json['fieldInt'] as int? ?? 42,
      (json['fieldDouble'] as num?)?.toDouble() ?? 3.14,
      json['fieldListEmpty'] as List<dynamic>? ?? [],
      (json['fieldSetEmpty'] as List<dynamic>?)?.toSet() ?? {},
      json['fieldMapEmpty'] as Map<String, dynamic>? ?? {},
      (json['fieldListSimple'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [1, 2, 3],
      (json['fieldSetSimple'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          {'entry1', 'entry2'},
      (json['fieldMapSimple'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          {'answer': 42},
      (json['fieldMapListString'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, (e as List<dynamic>).map((e) => e as String).toList()),
          ) ??
          {
            'root': ['child']
          },
      $enumDecodeNullable(_$GreekEnumMap, json['fieldEnum']) ?? Greek.beta,
      durationField: json['durationField'] == null
          ? Duration.zero
          : Duration(microseconds: json['durationField'] as int),
      constClass: json['constClass'] == null
          ? const ConstClass('value')
          : ConstClass.fromDynamoJson(
              json['constClass'] as Map<String, dynamic>),
      valueFromConverter: json['valueFromConverter'] == null
          ? const ConstClass('value')
          : const ConstClassConverter()
              .fromDynamoJson(json['valueFromConverter'] as String),
      valueFromFunction: json['valueFromFunction'] == null
          ? const ConstClass('value')
          : constClassFromDynamoJson(json['valueFromFunction'] as String),
    );

Map<String, dynamic> _$DefaultValueToDynamoJson(DefaultValue instance) =>
    <String, dynamic>{
      'fieldBool': instance.fieldBool,
      'fieldString': instance.fieldString,
      'fieldInt': instance.fieldInt,
      'fieldDouble': instance.fieldDouble,
      'fieldListEmpty': instance.fieldListEmpty,
      'fieldSetEmpty': instance.fieldSetEmpty.toList(),
      'fieldMapEmpty': instance.fieldMapEmpty,
      'fieldListSimple': instance.fieldListSimple,
      'fieldSetSimple': instance.fieldSetSimple.toList(),
      'fieldMapSimple': instance.fieldMapSimple,
      'fieldMapListString': instance.fieldMapListString,
      'durationField': instance.durationField.inMicroseconds,
      'fieldEnum': _$GreekEnumMap[instance.fieldEnum]!,
      'constClass': instance.constClass.toDynamoJson(),
      'valueFromConverter':
          const ConstClassConverter().toDynamoJson(instance.valueFromConverter),
      'valueFromFunction': constClassToDynamoJson(instance.valueFromFunction),
    };

const _$GreekEnumMap = {
  Greek.alpha: 'alpha',
  Greek.beta: 'beta',
  Greek.gamma: 'gamma',
  Greek.delta: 'delta',
};