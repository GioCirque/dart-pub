// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dynamo_annotation/dynamo_annotation.dart';

part 'input.type_double.g.dart';

@DynamoSerializable()
class SimpleClass {
  final double value;

  @DynamoKey(defaultValue: 3.14)
  double withDefault;

  SimpleClass(
    this.value,
    this.withDefault,
  );

  factory SimpleClass.fromDynamoJson(Map<String, Object?> json) =>
      _$SimpleClassFromDynamoJson(json);

  Map<String, Object?> toDynamoJson() => _$SimpleClassToDynamoJson(this);
}

@DynamoSerializable()
class SimpleClassNullable {
  final double? value;

  @DynamoKey(defaultValue: 3.14)
  double? withDefault;

  SimpleClassNullable(
    this.value,
    this.withDefault,
  );

  factory SimpleClassNullable.fromDynamoJson(Map<String, Object?> json) =>
      _$SimpleClassNullableFromDynamoJson(json);

  Map<String, Object?> toDynamoJson() =>
      _$SimpleClassNullableToDynamoJson(this);
}