//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:flowmotion_api/src/model/address.dart';
import 'package:flowmotion_api/src/model/location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_get_request_src.g.dart';

/// RouteGetRequestSrc
///
/// Properties:
/// * [kind] - Specifies if the source is an address or a location
/// * [address]
/// * [location]
@BuiltValue()
abstract class RouteGetRequestSrc
    implements Built<RouteGetRequestSrc, RouteGetRequestSrcBuilder> {
  /// Specifies if the source is an address or a location
  @BuiltValueField(wireName: r'kind')
  RouteGetRequestSrcKindEnum get kind;
  // enum kindEnum {  address,  location,  };

  @BuiltValueField(wireName: r'address')
  Address? get address;

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
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(RouteGetRequestSrcKindEnum),
    );
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
        specifiedType: const FullType(Address),
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
            specifiedType: const FullType(RouteGetRequestSrcKindEnum),
          ) as RouteGetRequestSrcKindEnum;
          result.kind = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Address),
          ) as Address;
          result.address.replace(valueDes);
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

class RouteGetRequestSrcKindEnum extends EnumClass {
  /// Specifies if the source is an address or a location
  @BuiltValueEnumConst(wireName: r'address')
  static const RouteGetRequestSrcKindEnum address =
      _$routeGetRequestSrcKindEnum_address;

  /// Specifies if the source is an address or a location
  @BuiltValueEnumConst(wireName: r'location')
  static const RouteGetRequestSrcKindEnum location =
      _$routeGetRequestSrcKindEnum_location;

  static Serializer<RouteGetRequestSrcKindEnum> get serializer =>
      _$routeGetRequestSrcKindEnumSerializer;

  const RouteGetRequestSrcKindEnum._(String name) : super(name);

  static BuiltSet<RouteGetRequestSrcKindEnum> get values =>
      _$routeGetRequestSrcKindEnumValues;
  static RouteGetRequestSrcKindEnum valueOf(String name) =>
      _$routeGetRequestSrcKindEnumValueOf(name);
}
