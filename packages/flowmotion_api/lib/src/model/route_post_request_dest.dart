//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:flowmotion_api/src/model/address.dart';
import 'package:flowmotion_api/src/model/location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_post_request_dest.g.dart';

/// RoutePostRequestDest
///
/// Properties:
/// * [kind] - Specifies if the destination is an address or a location
/// * [address] - Required if `kind` is `address`.
/// * [location] - Required if `kind` is `location`
@BuiltValue()
abstract class RoutePostRequestDest
    implements Built<RoutePostRequestDest, RoutePostRequestDestBuilder> {
  /// Specifies if the destination is an address or a location
  @BuiltValueField(wireName: r'kind')
  RoutePostRequestDestKindEnum? get kind;
  // enum kindEnum {  address,  location,  };

  /// Required if `kind` is `address`.
  @BuiltValueField(wireName: r'address')
  Address? get address;

  /// Required if `kind` is `location`
  @BuiltValueField(wireName: r'location')
  Location? get location;

  RoutePostRequestDest._();

  factory RoutePostRequestDest([void updates(RoutePostRequestDestBuilder b)]) =
      _$RoutePostRequestDest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoutePostRequestDestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoutePostRequestDest> get serializer =>
      _$RoutePostRequestDestSerializer();
}

class _$RoutePostRequestDestSerializer
    implements PrimitiveSerializer<RoutePostRequestDest> {
  @override
  final Iterable<Type> types = const [
    RoutePostRequestDest,
    _$RoutePostRequestDest
  ];

  @override
  final String wireName = r'RoutePostRequestDest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoutePostRequestDest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.kind != null) {
      yield r'kind';
      yield serializers.serialize(
        object.kind,
        specifiedType: const FullType(RoutePostRequestDestKindEnum),
      );
    }
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
        specifiedType: const FullType(Location),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RoutePostRequestDest object, {
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
    required RoutePostRequestDestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RoutePostRequestDestKindEnum),
          ) as RoutePostRequestDestKindEnum;
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
            specifiedType: const FullType(Location),
          ) as Location;
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
  RoutePostRequestDest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoutePostRequestDestBuilder();
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

class RoutePostRequestDestKindEnum extends EnumClass {
  /// Specifies if the destination is an address or a location
  @BuiltValueEnumConst(wireName: r'address')
  static const RoutePostRequestDestKindEnum address =
      _$routePostRequestDestKindEnum_address;

  /// Specifies if the destination is an address or a location
  @BuiltValueEnumConst(wireName: r'location')
  static const RoutePostRequestDestKindEnum location =
      _$routePostRequestDestKindEnum_location;

  static Serializer<RoutePostRequestDestKindEnum> get serializer =>
      _$routePostRequestDestKindEnumSerializer;

  const RoutePostRequestDestKindEnum._(String name) : super(name);

  static BuiltSet<RoutePostRequestDestKindEnum> get values =>
      _$routePostRequestDestKindEnumValues;
  static RoutePostRequestDestKindEnum valueOf(String name) =>
      _$routePostRequestDestKindEnumValueOf(name);
}
