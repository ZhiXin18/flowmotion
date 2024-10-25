//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:flowmotion_api/src/model/address.dart';
import 'package:flowmotion_api/src/model/location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_post_request_src.g.dart';

/// RoutePostRequestSrc
///
/// Properties:
/// * [kind]
/// * [location]
@BuiltValue()
abstract class RoutePostRequestSrc
    implements Built<RoutePostRequestSrc, RoutePostRequestSrcBuilder> {
  @BuiltValueField(wireName: r'kind')
  Address? get kind;

  @BuiltValueField(wireName: r'location')
  Location? get location;

  RoutePostRequestSrc._();

  factory RoutePostRequestSrc([void updates(RoutePostRequestSrcBuilder b)]) =
      _$RoutePostRequestSrc;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoutePostRequestSrcBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoutePostRequestSrc> get serializer =>
      _$RoutePostRequestSrcSerializer();
}

class _$RoutePostRequestSrcSerializer
    implements PrimitiveSerializer<RoutePostRequestSrc> {
  @override
  final Iterable<Type> types = const [
    RoutePostRequestSrc,
    _$RoutePostRequestSrc
  ];

  @override
  final String wireName = r'RoutePostRequestSrc';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoutePostRequestSrc object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.kind != null) {
      yield r'kind';
      yield serializers.serialize(
        object.kind,
        specifiedType: const FullType.nullable(Address),
      );
    }
    if (object.location != null) {
      yield r'location';
      yield serializers.serialize(
        object.location,
        specifiedType: const FullType.nullable(Location),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RoutePostRequestSrc object, {
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
    required RoutePostRequestSrcBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Address),
          ) as Address?;
          if (valueDes == null) continue;
          result.kind.replace(valueDes);
          break;
        case r'location':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Location),
          ) as Location?;
          if (valueDes == null) continue;
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
  RoutePostRequestSrc deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoutePostRequestSrcBuilder();
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
