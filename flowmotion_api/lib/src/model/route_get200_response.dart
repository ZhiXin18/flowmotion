//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:flowmotion_api/src/model/route_get200_response_routes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_get200_response.g.dart';

/// RouteGet200Response
///
/// Properties:
/// * [routes]
@BuiltValue()
abstract class RouteGet200Response
    implements Built<RouteGet200Response, RouteGet200ResponseBuilder> {
  @BuiltValueField(wireName: r'routes')
  BuiltList<RouteGet200ResponseRoutesInner>? get routes;

  RouteGet200Response._();

  factory RouteGet200Response([void updates(RouteGet200ResponseBuilder b)]) =
      _$RouteGet200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteGet200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteGet200Response> get serializer =>
      _$RouteGet200ResponseSerializer();
}

class _$RouteGet200ResponseSerializer
    implements PrimitiveSerializer<RouteGet200Response> {
  @override
  final Iterable<Type> types = const [
    RouteGet200Response,
    _$RouteGet200Response
  ];

  @override
  final String wireName = r'RouteGet200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteGet200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.routes != null) {
      yield r'routes';
      yield serializers.serialize(
        object.routes,
        specifiedType: const FullType(
            BuiltList, [FullType(RouteGet200ResponseRoutesInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteGet200Response object, {
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
    required RouteGet200ResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'routes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                BuiltList, [FullType(RouteGet200ResponseRoutesInner)]),
          ) as BuiltList<RouteGet200ResponseRoutesInner>;
          result.routes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteGet200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteGet200ResponseBuilder();
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
