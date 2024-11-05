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
/// * [congestion] - Optional. Whether to incorporate traffic congestion ratings into route planning. By default, this is enabled.
@BuiltValue()
abstract class RoutePostRequest
    implements Built<RoutePostRequest, RoutePostRequestBuilder> {
  @BuiltValueField(wireName: r'src')
  RoutePostRequestSrc get src;

  @BuiltValueField(wireName: r'dest')
  RoutePostRequestDest get dest;

  /// Optional. Whether to incorporate traffic congestion ratings into route planning. By default, this is enabled.
  @BuiltValueField(wireName: r'congestion')
  bool? get congestion;

  RoutePostRequest._();

  factory RoutePostRequest([void updates(RoutePostRequestBuilder b)]) =
      _$RoutePostRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoutePostRequestBuilder b) => b..congestion = true;

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
    yield r'src';
    yield serializers.serialize(
      object.src,
      specifiedType: const FullType(RoutePostRequestSrc),
    );
    yield r'dest';
    yield serializers.serialize(
      object.dest,
      specifiedType: const FullType(RoutePostRequestDest),
    );
    if (object.congestion != null) {
      yield r'congestion';
      yield serializers.serialize(
        object.congestion,
        specifiedType: const FullType(bool),
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
        case r'congestion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.congestion = valueDes;
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
