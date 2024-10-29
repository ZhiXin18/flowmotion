//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:flowmotion_api/src/model/location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'camera.g.dart';

/// Traffic camera capturing traffic images
///
/// Properties:
/// * [id]
/// * [capturedOn]
/// * [imageUrl]
/// * [retrievedOn]
/// * [location]
@BuiltValue()
abstract class Camera implements Built<Camera, CameraBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'captured_on')
  DateTime get capturedOn;

  @BuiltValueField(wireName: r'image_url')
  String get imageUrl;

  @BuiltValueField(wireName: r'retrieved_on')
  DateTime get retrievedOn;

  @BuiltValueField(wireName: r'location')
  Location get location;

  Camera._();

  factory Camera([void updates(CameraBuilder b)]) = _$Camera;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CameraBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Camera> get serializer => _$CameraSerializer();
}

class _$CameraSerializer implements PrimitiveSerializer<Camera> {
  @override
  final Iterable<Type> types = const [Camera, _$Camera];

  @override
  final String wireName = r'Camera';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Camera object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'captured_on';
    yield serializers.serialize(
      object.capturedOn,
      specifiedType: const FullType(DateTime),
    );
    yield r'image_url';
    yield serializers.serialize(
      object.imageUrl,
      specifiedType: const FullType(String),
    );
    yield r'retrieved_on';
    yield serializers.serialize(
      object.retrievedOn,
      specifiedType: const FullType(DateTime),
    );
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(Location),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Camera object, {
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
    required CameraBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'captured_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.capturedOn = valueDes;
          break;
        case r'image_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.imageUrl = valueDes;
          break;
        case r'retrieved_on':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.retrievedOn = valueDes;
          break;
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Location),
          ) as Location;
          result.location.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Camera deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CameraBuilder();
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
