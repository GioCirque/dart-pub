// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dynamo_annotation/dynamo_annotation.dart';

abstract class DefaultValue {
  bool get fieldBool;

  String get fieldString;

  int get fieldInt;

  double get fieldDouble;

  List get fieldListEmpty;

  Map get fieldMapEmpty;

  Set get fieldSetEmpty;

  List<int> get fieldListSimple;

  Set<String> get fieldSetSimple;

  Map<String, int> get fieldMapSimple;

  Map<String, List<String>> get fieldMapListString;

  Duration get durationField;

  Greek get fieldEnum;

  ConstClass get constClass;

  ConstClass get valueFromConverter;

  ConstClass get valueFromFunction;
}

enum Greek { alpha, beta, gamma, delta }

// Regression for https://github.com/google/json_serializable.dart/issues/903
class ConstClass {
  final String field;

  const ConstClass(this.field);

  factory ConstClass.fromDynamoJson(Map<String, dynamic> json) => ConstClass(
        json['field'] as String,
      );

  Map<String, dynamic> toDynamoJson() => <String, dynamic>{
        'field': field,
      };
}

ConstClass constClassFromDynamoJson(String json) => ConstClass(json);

String constClassToDynamoJson(ConstClass object) => object.field;

class ConstClassConverter extends DynamoConverter<ConstClass, String> {
  const ConstClassConverter();

  @override
  ConstClass fromDynamoJson(String json) => ConstClass(json);

  @override
  String toDynamoJson(ConstClass object) => object.field;
}