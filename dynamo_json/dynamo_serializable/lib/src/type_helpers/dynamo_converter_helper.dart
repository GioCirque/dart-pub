// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:dynamo_annotation/dynamo_annotation.dart';
import 'package:source_gen/source_gen.dart';
import 'package:source_helper/source_helper.dart';

import '../lambda_result.dart';
import '../shared_checkers.dart';
import '../type_helper.dart';
import '../utils.dart';

/// A [TypeHelper] that supports classes annotated with implementations of
/// [DynamoConverter].
class DynamoConverterHelper extends TypeHelper<TypeHelperContextWithConfig> {
  const DynamoConverterHelper();

  @override
  Object? serialize(
    DartType targetType,
    String expression,
    TypeHelperContextWithConfig context,
  ) {
    final converter = _typeConverter(targetType, context);

    if (converter == null) {
      return null;
    }

    if (!converter.fieldType.isNullableType && targetType.isNullableType) {
      const converterToJsonName = r'_$DynamoConverterToDynamoJson';
      context.addMember('''
Json? $converterToJsonName<Json, Value>(
  Value? value,
  Json? Function(Value value) toDynamoJson,
) => ${ifNullOrElse('value', 'null', 'toDynamoJson(value)')};
''');

      return _nullableDynamoConverterLambdaResult(
        converter,
        name: converterToJsonName,
        targetType: targetType,
        expression: expression,
        callback: '${converter.accessString}.toDynamoJson',
      );
    }

    return LambdaResult(expression, '${converter.accessString}.toDynamoJson');
  }

  @override
  Object? deserialize(
    DartType targetType,
    String expression,
    TypeHelperContextWithConfig context,
    bool defaultProvided,
  ) {
    final converter = _typeConverter(targetType, context);
    if (converter == null) {
      return null;
    }

    final asContent = asStatement(converter.jsonType);

    if (!converter.jsonType.isNullableType && targetType.isNullableType) {
      const converterFromJsonName = r'_$DynamoConverterFromDynamoJson';
      context.addMember('''
Value? $converterFromJsonName<Json, Value>(
  Object? json,
  Value? Function(Json json) fromDynamoJson,
) => ${ifNullOrElse('json', 'null', 'fromDynamoJson(json as Json)')};
''');

      return _nullableDynamoConverterLambdaResult(
        converter,
        name: converterFromJsonName,
        targetType: targetType,
        expression: expression,
        callback: '${converter.accessString}.fromDynamoJson',
      );
    }

    return LambdaResult(
      expression,
      '${converter.accessString}.fromDynamoJson',
      asContent: asContent,
    );
  }
}

String _nullableDynamoConverterLambdaResult(
  _DynamoConvertData converter, {
  required String name,
  required DartType targetType,
  required String expression,
  required String callback,
}) {
  final jsonDisplayString = typeToCode(converter.jsonType);
  final fieldTypeDisplayString = converter.isGeneric
      ? typeToCode(targetType)
      : typeToCode(converter.fieldType);

  return '$name<$jsonDisplayString, $fieldTypeDisplayString>('
      '$expression, $callback)';
}

class _DynamoConvertData {
  final String accessString;
  final DartType jsonType;
  final DartType fieldType;
  final bool isGeneric;

  _DynamoConvertData.className(
    String className,
    String accessor,
    this.jsonType,
    this.fieldType,
  )   : accessString = 'const $className${_withAccessor(accessor)}()',
        isGeneric = false;

  _DynamoConvertData.genericClass(
    String className,
    String genericTypeArg,
    String accessor,
    this.jsonType,
    this.fieldType,
  )   : accessString =
            '$className<$genericTypeArg>${_withAccessor(accessor)}()',
        isGeneric = true;

  _DynamoConvertData.propertyAccess(
    this.accessString,
    this.jsonType,
    this.fieldType,
  ) : isGeneric = false;

  static String _withAccessor(String accessor) =>
      accessor.isEmpty ? '' : '.$accessor';
}

_DynamoConvertData? _typeConverter(
  DartType targetType,
  TypeHelperContextWithConfig ctx,
) {
  List<_ConverterMatch> converterMatches(List<ElementAnnotation> items) => items
      .map(
        (annotation) => _compatibleMatch(
          targetType,
          annotation,
          annotation.computeConstantValue()!,
        ),
      )
      .whereType<_ConverterMatch>()
      .toList();

  var matchingAnnotations = converterMatches(ctx.fieldElement.metadata);

  if (matchingAnnotations.isEmpty) {
    matchingAnnotations =
        converterMatches(ctx.fieldElement.getter?.metadata ?? []);

    if (matchingAnnotations.isEmpty) {
      matchingAnnotations = converterMatches(ctx.classElement.metadata);

      if (matchingAnnotations.isEmpty) {
        matchingAnnotations = ctx.config.converters
            .map((e) => _compatibleMatch(targetType, null, e))
            .whereType<_ConverterMatch>()
            .toList();
      }
    }
  }

  return _typeConverterFrom(matchingAnnotations, targetType);
}

_DynamoConvertData? _typeConverterFrom(
  List<_ConverterMatch> matchingAnnotations,
  DartType targetType,
) {
  if (matchingAnnotations.isEmpty) {
    return null;
  }

  if (matchingAnnotations.length > 1) {
    final targetTypeCode = typeToCode(targetType);
    throw InvalidGenerationSourceError(
      'Found more than one matching converter for `$targetTypeCode`.',
      element: matchingAnnotations[1].elementAnnotation?.element,
    );
  }

  final match = matchingAnnotations.single;

  final annotationElement = match.elementAnnotation?.element;
  if (annotationElement is PropertyAccessorElement) {
    final enclosing = annotationElement.enclosingElement3;

    var accessString = annotationElement.name;

    if (enclosing is ClassElement) {
      accessString = '${enclosing.name}.$accessString';
    }

    return _DynamoConvertData.propertyAccess(
      accessString,
      match.jsonType,
      match.fieldType,
    );
  }

  final reviver = ConstantReader(match.annotation).revive();

  if (reviver.namedArguments.isNotEmpty ||
      reviver.positionalArguments.isNotEmpty) {
    throw InvalidGenerationSourceError(
      'Generators with constructor arguments are not supported.',
      element: match.elementAnnotation?.element,
    );
  }

  if (match.genericTypeArg != null) {
    return _DynamoConvertData.genericClass(
      match.annotation.type!.element2!.name!,
      match.genericTypeArg!,
      reviver.accessor,
      match.jsonType,
      match.fieldType,
    );
  }

  return _DynamoConvertData.className(
    match.annotation.type!.element2!.name!,
    reviver.accessor,
    match.jsonType,
    match.fieldType,
  );
}

class _ConverterMatch {
  final DartObject annotation;
  final DartType fieldType;
  final DartType jsonType;
  final ElementAnnotation? elementAnnotation;
  final String? genericTypeArg;

  _ConverterMatch(
    this.elementAnnotation,
    this.annotation,
    this.jsonType,
    this.genericTypeArg,
    this.fieldType,
  );
}

_ConverterMatch? _compatibleMatch(
  DartType targetType,
  ElementAnnotation? annotation,
  DartObject constantValue,
) {
  final converterClassElement = constantValue.type!.element2 as ClassElement;

  final jsonConverterSuper =
      converterClassElement.allSupertypes.singleWhereOrNull(
    (e) => _dynamoConverterChecker.isExactly(e.element2),
  );

  if (jsonConverterSuper == null) {
    return null;
  }

  assert(jsonConverterSuper.element2.typeParameters.length == 2);
  assert(jsonConverterSuper.typeArguments.length == 2);

  final fieldType = jsonConverterSuper.typeArguments[0];

  // Allow assigning T to T?
  if (fieldType == targetType || fieldType == targetType.promoteNonNullable()) {
    return _ConverterMatch(
      annotation,
      constantValue,
      jsonConverterSuper.typeArguments[1],
      null,
      fieldType,
    );
  }

  if (fieldType is TypeParameterType && targetType is TypeParameterType) {
    assert(annotation?.element is! PropertyAccessorElement);
    assert(converterClassElement.typeParameters.isNotEmpty);
    if (converterClassElement.typeParameters.length > 1) {
      throw InvalidGenerationSourceError(
          '`DynamoConverter` implementations can have no more than one type '
          'argument. `${converterClassElement.name}` has '
          '${converterClassElement.typeParameters.length}.',
          element: converterClassElement);
    }

    return _ConverterMatch(
      annotation,
      constantValue,
      jsonConverterSuper.typeArguments[1],
      '${targetType.element2.name}${targetType.isNullableType ? '?' : ''}',
      fieldType,
    );
  }

  return null;
}

const _dynamoConverterChecker = TypeChecker.fromRuntime(DynamoConverter);