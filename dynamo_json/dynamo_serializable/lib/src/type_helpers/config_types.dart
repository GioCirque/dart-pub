// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/constant/value.dart';
import 'package:dynamo_annotation/dynamo_annotation.dart';

/// Represents values from [DynamoKey] when merged with local configuration.
class KeyConfig {
  final String? defaultValue;

  final bool disallowNullValue;

  final bool ignore;

  final bool includeIfNull;

  final String name;

  final bool required;

  final String? unknownEnumValue;

  final String? readValueFunctionName;

  KeyConfig({
    required this.defaultValue,
    required this.disallowNullValue,
    required this.ignore,
    required this.includeIfNull,
    required this.name,
    required this.readValueFunctionName,
    required this.required,
    required this.unknownEnumValue,
  });
}

/// Represents values from [DynamoSerializable] when merged with local
/// configuration.
///
/// Values are all known, so types are non-nullable.
class ClassConfig {
  final bool anyMap;
  final bool checked;
  final String constructor;
  final bool createFactory;
  final bool createFieldMap;
  final bool disallowUnrecognizedKeys;
  final FieldRename fieldRename;
  final bool genericArgumentFactories;
  final bool ignoreUnannotated;
  final bool includeIfNull;
  final Map<String, String> ctorParamDefaults;
  final List<DartObject> converters;

  const ClassConfig({
    required this.anyMap,
    required this.checked,
    required this.constructor,
    required this.createFactory,
    required this.createFieldMap,
    required this.disallowUnrecognizedKeys,
    required this.fieldRename,
    required this.genericArgumentFactories,
    required this.ignoreUnannotated,
    required this.includeIfNull,
    this.converters = const [],
    this.ctorParamDefaults = const {},
  });

  factory ClassConfig.fromDynamoSerializable(DynamoSerializable config) =>
      // #CHANGE WHEN UPDATING json_annotation
      ClassConfig(
        checked: config.checked ?? ClassConfig.defaults.checked,
        anyMap: config.anyMap ?? ClassConfig.defaults.anyMap,
        constructor: config.constructor ?? ClassConfig.defaults.constructor,
        createFieldMap:
            config.createFieldMap ?? ClassConfig.defaults.createFieldMap,
        createFactory:
            config.createFactory ?? ClassConfig.defaults.createFactory,
        ignoreUnannotated:
            config.ignoreUnannotated ?? ClassConfig.defaults.ignoreUnannotated,
        includeIfNull:
            config.includeIfNull ?? ClassConfig.defaults.includeIfNull,
        genericArgumentFactories: config.genericArgumentFactories ??
            ClassConfig.defaults.genericArgumentFactories,
        fieldRename: config.fieldRename ?? ClassConfig.defaults.fieldRename,
        disallowUnrecognizedKeys: config.disallowUnrecognizedKeys ??
            ClassConfig.defaults.disallowUnrecognizedKeys,
        // TODO typeConverters = []
      );

  /// An instance of [DynamoSerializable] with all fields set to their default
  /// values.
  static const defaults = ClassConfig(
    anyMap: false,
    checked: false,
    constructor: '',
    createFactory: true,
    createFieldMap: false,
    disallowUnrecognizedKeys: false,
    fieldRename: FieldRename.none,
    genericArgumentFactories: false,
    ignoreUnannotated: false,
    includeIfNull: true,
  );

  DynamoSerializable toDynamoSerializable() => DynamoSerializable(
        checked: checked,
        anyMap: anyMap,
        constructor: constructor,
        createFactory: createFactory,
        createFieldMap: createFieldMap,
        ignoreUnannotated: ignoreUnannotated,
        includeIfNull: includeIfNull,
        genericArgumentFactories: genericArgumentFactories,
        fieldRename: fieldRename,
        disallowUnrecognizedKeys: disallowUnrecognizedKeys,
        // TODO typeConverters = []
      );
}