//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:flowmotion_api/src/model/address.dart';
import 'package:flowmotion_api/src/model/location.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'route_post_request_src_spec.g.dart';

/// RoutePostRequestSrcSpec
///
/// Properties:
/// * [text] - Full address text
/// * [postcode] - Postal code of the source address
/// * [latitude] - Latitude of the location
/// * [longitude] - Longitude of the location
@BuiltValue()
abstract class RoutePostRequestSrcSpec
    implements Built<RoutePostRequestSrcSpec, RoutePostRequestSrcSpecBuilder> {
  /// One Of [Address], [Location]
  OneOf get oneOf;

  RoutePostRequestSrcSpec._();

  factory RoutePostRequestSrcSpec(
          [void updates(RoutePostRequestSrcSpecBuilder b)]) =
      _$RoutePostRequestSrcSpec;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoutePostRequestSrcSpecBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoutePostRequestSrcSpec> get serializer =>
      _$RoutePostRequestSrcSpecSerializer();
}

class _$RoutePostRequestSrcSpecSerializer
    implements PrimitiveSerializer<RoutePostRequestSrcSpec> {
  @override
  final Iterable<Type> types = const [
    RoutePostRequestSrcSpec,
    _$RoutePostRequestSrcSpec
  ];

  @override
  final String wireName = r'RoutePostRequestSrcSpec';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoutePostRequestSrcSpec object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    RoutePostRequestSrcSpec object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value,
        specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  RoutePostRequestSrcSpec deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoutePostRequestSrcSpecBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [
      FullType(Address),
      FullType(Location),
    ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc,
        specifiedType: targetType) as OneOf;
    return result.build();
  }
}
