import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class DynamoJson {
  const DynamoJson();
}

@Target({TargetKind.field, TargetKind.getter, TargetKind.setter})
class DynamoIgnore {
  const DynamoIgnore();
}