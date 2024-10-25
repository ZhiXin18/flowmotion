//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:flowmotion_api/src/model/route_post_request_dest.dart';
import 'package:flowmotion_api/src/model/route_post_request_src.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_post_request.g.dart';

/// RoutePostRequest
///
/// Properties:
/// * [src]
/// * [dest]
@BuiltValue()
abstract class RoutePostRequest
    implements Built<RoutePostRequest, RoutePostRequestBuilder> {
  @BuiltValueField(wireName: r'src')
  RoutePostRequestSrc? get src;

  @BuiltValueField(wireName: r'dest')
  RoutePostRequestDest? get dest;

  RoutePostRequest._();

  factory RoutePostRequest([void updates(RoutePostRequestBuilder b)]) =
      _$RoutePostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoutePostRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoutePostRequest> get serializer =>
      _$RoutePostRequestSerializer();
}

class _$RoutePostRequestSerializer
    implements PrimitiveSerializer<RoutePostRequest> {
  @override
  final Iterable<Type> types = const [RoutePostRequest, _$RoutePostRequest];

  @override
  final String wireName = r'RoutePostRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoutePostRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.src != null) {
      yield r'src';
      yield serializers.serialize(
        object.src,
        specifiedType: const FullType(RoutePostRequestSrc),
      );
    }
    if (object.dest != null) {
      yield r'dest';
      yield serializers.serialize(
        object.dest,
        specifiedType: const FullType(RoutePostRequestDest),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RoutePostRequest object, {
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
    required RoutePostRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'src':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RoutePostRequestSrc),
          ) as RoutePostRequestSrc;
          result.src.replace(valueDes);
          break;
        case r'dest':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RoutePostRequestDest),
          ) as RoutePostRequestDest;
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
  RoutePostRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoutePostRequestBuilder();
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
