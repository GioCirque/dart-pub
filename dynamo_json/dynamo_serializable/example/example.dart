// Copyright (c) 2017, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dynamo_annotation/dynamo_annotation.dart';

part 'example.g.dart';

@DynamoSerializable()
class Person {
  /// The generated code assumes these values exist in JSON.
  final String firstName, lastName;

  /// The generated code below handles if the corresponding JSON value doesn't
  /// exist or is empty.
  final DateTime? dateOfBirth;

  Person({required this.firstName, required this.lastName, this.dateOfBirth});

  /// Connect the generated [_$PersonFromDynamoJson] function to the
  /// `fromDynamoJson` factory.
  factory Person.fromJson(Map<String, dynamic> json) =>
      _$PersonFromDynamoJson(json);

  /// Connect the generated [_$PersonToDynamoJson] function to the
  /// `toDynamoJson` method.
  Map<String, dynamic> toJson() => _$PersonToDynamoJson(this);
}