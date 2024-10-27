//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:flowmotion_api/src/model/address.dart';
import 'package:flowmotion_api/src/model/location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_get_request_src.g.dart';

/// RouteGetRequestSrc
///
/// Properties:
/// * [kind]
/// * [location]
@BuiltValue()
abstract class RouteGetRequestSrc
    implements Built<RouteGetRequestSrc, RouteGetRequestSrcBuilder> {
  @BuiltValueField(wireName: r'kind')
  Address? get kind;

  @BuiltValueField(wireName: r'location')
  Location? get location;

  RouteGetRequestSrc._();

  factory RouteGetRequestSrc([void updates(RouteGetRequestSrcBuilder b)]) =
      _$RouteGetRequestSrc;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteGetRequestSrcBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteGetRequestSrc> get serializer =>
      _$RouteGetRequestSrcSerializer();
}

class _$RouteGetRequestSrcSerializer
    implements PrimitiveSerializer<RouteGetRequestSrc> {
  @override
  final Iterable<Type> types = const [RouteGetRequestSrc, _$RouteGetRequestSrc];

  @override
  final String wireName = r'RouteGetRequestSrc';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteGetRequestSrc object, {
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
    RouteGetRequestSrc object, {
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
    required RouteGetRequestSrcBuilder result,
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
  RouteGetRequestSrc deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteGetRequestSrcBuilder();
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
