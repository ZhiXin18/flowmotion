//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'rating.g.dart';

/// Traffic congestion rating
///
/// Properties:
/// * [ratedOn]
/// * [modelId]
/// * [value] - 0-1 congestion rating with 1 being 'most congested'
@BuiltValue()
abstract class Rating implements Built<Rating, RatingBuilder> {
  @BuiltValueField(wireName: r'rated_on')
  DateTime get ratedOn;

  @BuiltValueField(wireName: r'model_id')
  String get modelId;

  /// 0-1 congestion rating with 1 being 'most congested'
  @BuiltValueField(wireName: r'value')
  num get value;

  Rating._();

  factory Rating([void updates(RatingBuilder b)]) = _$Rating;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RatingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Rating> get serializer => _$RatingSerializer();
}

class _$RatingSerializer implements PrimitiveSerializer<Rating> {
  @override
  final Iterable<Type> types = const [Rating, _$Rating];

  @override
  final String wireName = r'Rating';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Rating object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'rated_on';
    yield serializers.serialize(
      object.ratedOn,
      specifiedType: const FullType(DateTime),
    );
    yield r'model_id';
    yield serializers.serialize(
      object.modelId,
      specifiedType: const FullType(String),
    );
    yield r'value';
    yield serializers.serialize(
      object.value,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Rating object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RatingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'rated_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.ratedOn = valueDes;
          break;
        case r'model_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.modelId = valueDes;
          break;
        case r'value':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.value = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Rating deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RatingBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}
