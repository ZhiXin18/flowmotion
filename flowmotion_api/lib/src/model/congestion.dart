//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:flowmotion_api/src/model/rating.dart';
import 'package:flowmotion_api/src/model/camera.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'congestion.g.dart';

/// Traffic camera congestion rating.
///
/// Properties:
/// * [camera]
/// * [rating]
/// * [updatedOn]
@BuiltValue()
abstract class Congestion implements Built<Congestion, CongestionBuilder> {
  @BuiltValueField(wireName: r'camera')
  Camera get camera;

  @BuiltValueField(wireName: r'rating')
  Rating get rating;

  @BuiltValueField(wireName: r'updated_on')
  DateTime get updatedOn;

  Congestion._();

  factory Congestion([void updates(CongestionBuilder b)]) = _$Congestion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CongestionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Congestion> get serializer => _$CongestionSerializer();
}

class _$CongestionSerializer implements PrimitiveSerializer<Congestion> {
  @override
  final Iterable<Type> types = const [Congestion, _$Congestion];

  @override
  final String wireName = r'Congestion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Congestion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'camera';
    yield serializers.serialize(
      object.camera,
      specifiedType: const FullType(Camera),
    );
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(Rating),
    );
    yield r'updated_on';
    yield serializers.serialize(
      object.updatedOn,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Congestion object, {
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
    required CongestionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'camera':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Camera),
          ) as Camera;
          result.camera.replace(valueDes);
          break;
        case r'rating':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Rating),
          ) as Rating;
          result.rating.replace(valueDes);
          break;
        case r'updated_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.updatedOn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Congestion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CongestionBuilder();
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
