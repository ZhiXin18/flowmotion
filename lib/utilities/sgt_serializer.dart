import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';

/// Asia/Singapore serializer for [DateTime].
class SGTDateTimeSerializer implements PrimitiveSerializer<DateTime> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>([DateTime]);
  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime dateTime,
      {FullType specifiedType = FullType.unspecified}) {
    return "${dateTime.toIso8601String()}+08:00";
  }

  @override
  DateTime deserialize(Serializers serializers, Object? serialized,
      {FullType specifiedType = FullType.unspecified}) {
    return DateTime.parse(serialized as String);
  }
}
