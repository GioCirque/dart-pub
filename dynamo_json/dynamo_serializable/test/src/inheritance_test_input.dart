part of '_json_serializable_test_input.dart';

@ShouldGenerate(r'''
SubType _$SubTypeFromDynamoJson(Map<String, dynamic> json) => SubType(
      json['subTypeViaCtor'] as int,
      json['super-final-field'] as int,
    )
      ..superReadWriteField = json['superReadWriteField'] as int?
      ..subTypeReadWrite = json['subTypeReadWrite'] as int;

Map<String, dynamic> _$SubTypeToDynamoJson(SubType instance) {
  final val = <String, dynamic>{
    'super-final-field': instance.superFinalField,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('superReadWriteField', instance.superReadWriteField);
  val['subTypeViaCtor'] = instance.subTypeViaCtor;
  val['subTypeReadWrite'] = instance.subTypeReadWrite;
  return val;
}
''')
@DynamoSerializable()
class SubType extends SuperType {
  late final int subTypeViaCtor;
  late int subTypeReadWrite;

  SubType(this.subTypeViaCtor, int superFinalField) : super(superFinalField);
}

// NOTE: `SuperType` is intentionally after `SubType` in the source file to
// validate field ordering semantics.
class SuperType {
  @DynamoKey(name: 'super-final-field')
  final int? superFinalField;

  @DynamoKey(includeIfNull: false)
  int? superReadWriteField;

  SuperType(this.superFinalField);

  /// Add a property to try to throw-off the generator
  /// Since `priceHalf` is final and not in the constructor, it will be excluded
  int get priceHalf => priceFraction(2);

  /// Add a method to try to throw-off the generator
  int priceFraction(int other) => superFinalField! ~/ other;
}

@ShouldGenerate(r'''
Map<String, dynamic> _$SubTypeWithAnnotatedFieldOverrideExtendsToDynamoJson(
    SubTypeWithAnnotatedFieldOverrideExtends instance) {
  final val = <String, dynamic>{
    'super-final-field': instance.superFinalField,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('superReadWriteField', instance.superReadWriteField);
  val['priceHalf'] = instance.priceHalf;
  return val;
}
''')
@DynamoSerializable(createFactory: false)
class SubTypeWithAnnotatedFieldOverrideExtends extends SuperType {
  SubTypeWithAnnotatedFieldOverrideExtends(int super.superTypeViaCtor);
}

@ShouldGenerate(r'''
Map<String, dynamic>
    _$SubTypeWithAnnotatedFieldOverrideExtendsWithOverridesToDynamoJson(
            SubTypeWithAnnotatedFieldOverrideExtendsWithOverrides instance) =>
        <String, dynamic>{
          'priceHalf': instance.priceHalf,
          'superReadWriteField': instance.superReadWriteField,
          'super-final-field': instance.superFinalField,
        };
''')
@DynamoSerializable(createFactory: false)
class SubTypeWithAnnotatedFieldOverrideExtendsWithOverrides extends SuperType {
  SubTypeWithAnnotatedFieldOverrideExtendsWithOverrides(
      int super.superTypeViaCtor);

  /// The annotation applied here overrides the annotation in [SuperType].
  @DynamoKey(includeIfNull: true)
  @override
  int? get superReadWriteField => super.superReadWriteField;

  @override
  set superReadWriteField(int? value) {
    super.superReadWriteField = value;
  }

  /// The order is picked up by this override, but the annotation is still
  /// applied from [SuperType].
  @override
  int? get superFinalField => super.superFinalField;
}

@ShouldGenerate(r'''
Map<String, dynamic> _$SubTypeWithAnnotatedFieldOverrideImplementsToDynamoJson(
        SubTypeWithAnnotatedFieldOverrideImplements instance) =>
    <String, dynamic>{
      'superReadWriteField': instance.superReadWriteField,
      'superFinalField': instance.superFinalField,
    };
''')
@DynamoSerializable(createFactory: false)
class SubTypeWithAnnotatedFieldOverrideImplements implements SuperType {
  // Note the order of fields in the output is determined by this class
  @override
  int? superReadWriteField;

  @DynamoKey(ignore: true)
  @override
  int get priceHalf => 42;

  /// Since the relationship is `implements` no [DynamoKey] values from
  /// [SuperType] are honored.
  @override
  int get superFinalField => 42;

  @override
  int priceFraction(int other) => other;
}