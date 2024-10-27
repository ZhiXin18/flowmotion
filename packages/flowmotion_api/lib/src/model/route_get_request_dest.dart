//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:flowmotion_api/src/model/address.dart';
import 'package:flowmotion_api/src/model/location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_get_request_dest.g.dart';

/// RouteGetRequestDest
///
/// Properties:
/// * [kind] - Specifies if the destination is an address or a location
/// * [address]
/// * [location]
@BuiltValue()
abstract class RouteGetRequestDest
    implements Built<RouteGetRequestDest, RouteGetRequestDestBuilder> {
  /// Specifies if the destination is an address or a location
  @BuiltValueField(wireName: r'kind')
  RouteGetRequestDestKindEnum? get kind;
  // enum kindEnum {  address,  location,  };

  @BuiltValueField(wireName: r'address')
  Address? get address;

  @BuiltValueField(wireName: r'location')
  Location? get location;

  RouteGetRequestDest._();

  factory RouteGetRequestDest([void updates(RouteGetRequestDestBuilder b)]) =
      _$RouteGetRequestDest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteGetRequestDestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteGetRequestDest> get serializer =>
      _$RouteGetRequestDestSerializer();
}

class _$RouteGetRequestDestSerializer
    implements PrimitiveSerializer<RouteGetRequestDest> {
  @override
  final Iterable<Type> types = const [
    RouteGetRequestDest,
    _$RouteGetRequestDest
  ];

  @override
  final String wireName = r'RouteGetRequestDest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteGetRequestDest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.kind != null) {
      yield r'kind';
      yield serializers.serialize(
        object.kind,
        specifiedType: const FullType(RouteGetRequestDestKindEnum),
      );
    }
    if (object.address != null) {
      yield r'address';
      yield serializers.serialize(
        object.address,
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
    RouteGetRequestDest object, {
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
    required RouteGetRequestDestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RouteGetRequestDestKindEnum),
          ) as RouteGetRequestDestKindEnum;
          result.kind = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Address),
          ) as Address?;
          if (valueDes == null) continue;
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
  RouteGetRequestDest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteGetRequestDestBuilder();
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

class RouteGetRequestDestKindEnum extends EnumClass {
  /// Specifies if the destination is an address or a location
  @BuiltValueEnumConst(wireName: r'address')
  static const RouteGetRequestDestKindEnum address =
      _$routeGetRequestDestKindEnum_address;

  /// Specifies if the destination is an address or a location
  @BuiltValueEnumConst(wireName: r'location')
  static const RouteGetRequestDestKindEnum location =
      _$routeGetRequestDestKindEnum_location;

  static Serializer<RouteGetRequestDestKindEnum> get serializer =>
      _$routeGetRequestDestKindEnumSerializer;

  const RouteGetRequestDestKindEnum._(String name) : super(name);

  static BuiltSet<RouteGetRequestDestKindEnum> get values =>
      _$routeGetRequestDestKindEnumValues;
  static RouteGetRequestDestKindEnum valueOf(String name) =>
      _$routeGetRequestDestKindEnumValueOf(name);
}
