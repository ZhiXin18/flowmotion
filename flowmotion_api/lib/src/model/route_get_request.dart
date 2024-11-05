//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:flowmotion_api/src/model/route_get_request_dest.dart';
import 'package:flowmotion_api/src/model/route_get_request_src.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_get_request.g.dart';

/// RouteGetRequest
///
/// Properties:
/// * [src]
/// * [dest]
@BuiltValue()
abstract class RouteGetRequest
    implements Built<RouteGetRequest, RouteGetRequestBuilder> {
  @BuiltValueField(wireName: r'src')
  RouteGetRequestSrc get src;

  @BuiltValueField(wireName: r'dest')
  RouteGetRequestDest get dest;

  RouteGetRequest._();

  factory RouteGetRequest([void updates(RouteGetRequestBuilder b)]) =
      _$RouteGetRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteGetRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteGetRequest> get serializer =>
      _$RouteGetRequestSerializer();
}

class _$RouteGetRequestSerializer
    implements PrimitiveSerializer<RouteGetRequest> {
  @override
  final Iterable<Type> types = const [RouteGetRequest, _$RouteGetRequest];

  @override
  final String wireName = r'RouteGetRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteGetRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'src';
    yield serializers.serialize(
      object.src,
      specifiedType: const FullType(RouteGetRequestSrc),
    );
    yield r'dest';
    yield serializers.serialize(
      object.dest,
      specifiedType: const FullType(RouteGetRequestDest),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteGetRequest object, {
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
    required RouteGetRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'src':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteGetRequestSrc),
          ) as RouteGetRequestSrc;
          result.src.replace(valueDes);
          break;
        case r'dest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteGetRequestDest),
          ) as RouteGetRequestDest;
          result.dest.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteGetRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteGetRequestBuilder();
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
