// ignore_for_file: annotate_overrides

import 'package:dynamo_annotation/dynamo_annotation.dart';

import 'default_value_interface.dart';
import 'default_value_interface.dart' as dvi hide Greek;

part 'implicit_default_value.g.dart';

dvi.DefaultValue fromDynamoJson(Map<String, dynamic> json) =>
    _$DefaultValueImplicitFromDynamoJson(json);

@DynamoSerializable()
class DefaultValueImplicit implements dvi.DefaultValue {
  final bool fieldBool;

  final String fieldString;

  final int fieldInt;

  final double fieldDouble;

  final List fieldListEmpty;

  final Set fieldSetEmpty;

  final Map fieldMapEmpty;

  final List<int> fieldListSimple;

  final Set<String> fieldSetSimple;

  final Map<String, int> fieldMapSimple;

  final Map<String, List<String>> fieldMapListString;

  final Duration durationField;

  final Greek fieldEnum;

  final ConstClass constClass;

  @ConstClassConverter()
  ConstClass valueFromConverter;

  @DynamoKey(
      fromDynamoJson: constClassFromDynamoJson,
      toDynamoJson: constClassToDynamoJson)
  ConstClass valueFromFunction;

  DefaultValueImplicit({
    this.fieldBool = true,
    this.fieldString = 'string',
    this.fieldInt = 42,
    this.fieldDouble = 3.14,
    this.fieldListEmpty = const [],
    this.fieldSetEmpty = const {},
    this.fieldMapEmpty = const {},
    this.fieldListSimple = const [1, 2, 3],
    this.fieldSetSimple = const {'entry1', 'entry2'},
    this.fieldMapSimple = const {'answer': 42},
    this.fieldMapListString = const {
      'root': ['child']
    },
    this.fieldEnum = Greek.beta,
    this.durationField = const Duration(),
    this.constClass = const ConstClass('value'),
    this.valueFromConverter = const ConstClass('value'),
    this.valueFromFunction = const ConstClass('value'),
  });

  factory DefaultValueImplicit.fromDynamoJson(Map<String, dynamic> json) =>
      _$DefaultValueImplicitFromDynamoJson(json);

  Map<String, dynamic> toDynamoJson() =>
      _$DefaultValueImplicitToDynamoJson(this);
}