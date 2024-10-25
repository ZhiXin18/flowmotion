//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:flowmotion_api/src/model/route_post200_response_routes_inner_steps_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_post200_response_routes_inner.g.dart';

/// RoutePost200ResponseRoutesInner
///
/// Properties:
/// * [geometry] - Polyline (precision 5) for drawing the entire route on a map
/// * [duration] - Estimated travel duration in seconds
/// * [distance] - Total travel distance in meters
/// * [steps]
@BuiltValue()
abstract class RoutePost200ResponseRoutesInner
    implements
        Built<RoutePost200ResponseRoutesInner,
            RoutePost200ResponseRoutesInnerBuilder> {
  /// Polyline (precision 5) for drawing the entire route on a map
  @BuiltValueField(wireName: r'geometry')
  String? get geometry;

  /// Estimated travel duration in seconds
  @BuiltValueField(wireName: r'duration')
  double? get duration;

  /// Total travel distance in meters
  @BuiltValueField(wireName: r'distance')
  double? get distance;

  @BuiltValueField(wireName: r'steps')
  BuiltList<RoutePost200ResponseRoutesInnerStepsInner>? get steps;

  RoutePost200ResponseRoutesInner._();

  factory RoutePost200ResponseRoutesInner(
          [void updates(RoutePost200ResponseRoutesInnerBuilder b)]) =
      _$RoutePost200ResponseRoutesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoutePost200ResponseRoutesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoutePost200ResponseRoutesInner> get serializer =>
      _$RoutePost200ResponseRoutesInnerSerializer();
}

class _$RoutePost200ResponseRoutesInnerSerializer
    implements PrimitiveSerializer<RoutePost200ResponseRoutesInner> {
  @override
  final Iterable<Type> types = const [
    RoutePost200ResponseRoutesInner,
    _$RoutePost200ResponseRoutesInner
  ];

  @override
  final String wireName = r'RoutePost200ResponseRoutesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoutePost200ResponseRoutesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.geometry != null) {
      yield r'geometry';
      yield serializers.serialize(
        object.geometry,
        specifiedType: const FullType(String),
      );
    }
    if (object.duration != null) {
      yield r'duration';
      yield serializers.serialize(
        object.duration,
        specifiedType: const FullType(double),
      );
    }
    if (object.distance != null) {
      yield r'distance';
      yield serializers.serialize(
        object.distance,
        specifiedType: const FullType(double),
      );
    }
    if (object.steps != null) {
      yield r'steps';
      yield serializers.serialize(
        object.steps,
        specifiedType: const FullType(
            BuiltList, [FullType(RoutePost200ResponseRoutesInnerStepsInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RoutePost200ResponseRoutesInner object, {
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
    required RoutePost200ResponseRoutesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'geometry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.geometry = valueDes;
          break;
        case r'duration':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.duration = valueDes;
          break;
        case r'distance':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(double),
          ) as double;
          result.distance = valueDes;
          break;
        case r'steps':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList,
                [FullType(RoutePost200ResponseRoutesInnerStepsInner)]),
          ) as BuiltList<RoutePost200ResponseRoutesInnerStepsInner>;
          result.steps.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RoutePost200ResponseRoutesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoutePost200ResponseRoutesInnerBuilder();
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
