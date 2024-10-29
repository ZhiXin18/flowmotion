//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:flowmotion_api/src/model/route_post200_response_routes_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_post200_response.g.dart';

/// RoutePost200Response
///
/// Properties:
/// * [routes]
@BuiltValue()
abstract class RoutePost200Response
    implements Built<RoutePost200Response, RoutePost200ResponseBuilder> {
  @BuiltValueField(wireName: r'routes')
  BuiltList<RoutePost200ResponseRoutesInner>? get routes;

  RoutePost200Response._();

  factory RoutePost200Response([void updates(RoutePost200ResponseBuilder b)]) =
      _$RoutePost200Response;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoutePost200ResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoutePost200Response> get serializer =>
      _$RoutePost200ResponseSerializer();
}

class _$RoutePost200ResponseSerializer
    implements PrimitiveSerializer<RoutePost200Response> {
  @override
  final Iterable<Type> types = const [
    RoutePost200Response,
    _$RoutePost200Response
  ];

  @override
  final String wireName = r'RoutePost200Response';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoutePost200Response object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.routes != null) {
      yield r'routes';
      yield serializers.serialize(
        object.routes,
        specifiedType: const FullType(
            BuiltList, [FullType(RoutePost200ResponseRoutesInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RoutePost200Response object, {
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
    required RoutePost200ResponseBuilder result,
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
                BuiltList, [FullType(RoutePost200ResponseRoutesInner)]),
          ) as BuiltList<RoutePost200ResponseRoutesInner>;
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
  RoutePost200Response deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoutePost200ResponseBuilder();
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
