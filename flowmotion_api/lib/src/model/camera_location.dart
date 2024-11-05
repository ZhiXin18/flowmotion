//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'camera_location.g.dart';

/// CameraLocation
///
/// Properties:
/// * [longitude]
/// * [latitude]
@BuiltValue()
abstract class CameraLocation
    implements Built<CameraLocation, CameraLocationBuilder> {
  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  CameraLocation._();

  factory CameraLocation([void updates(CameraLocationBuilder b)]) =
      _$CameraLocation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CameraLocationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CameraLocation> get serializer =>
      _$CameraLocationSerializer();
}

class _$CameraLocationSerializer
    implements PrimitiveSerializer<CameraLocation> {
  @override
  final Iterable<Type> types = const [CameraLocation, _$CameraLocation];

  @override
  final String wireName = r'CameraLocation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CameraLocation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CameraLocation object, {
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
    required CameraLocationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CameraLocation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CameraLocationBuilder();
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
