//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:flowmotion_api/src/model/route_get200_response_routes_inner_steps_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_get200_response_routes_inner.g.dart';

/// RouteGet200ResponseRoutesInner
///
/// Properties:
/// * [geometry] - Polyline (precision 5) for drawing the entire route on a map
/// * [duration] - Estimated travel duration in seconds
/// * [distance] - Total travel distance in meters
/// * [steps]
@BuiltValue()
abstract class RouteGet200ResponseRoutesInner
    implements
        Built<RouteGet200ResponseRoutesInner,
            RouteGet200ResponseRoutesInnerBuilder> {
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
  BuiltList<RouteGet200ResponseRoutesInnerStepsInner>? get steps;

  RouteGet200ResponseRoutesInner._();

  factory RouteGet200ResponseRoutesInner(
          [void updates(RouteGet200ResponseRoutesInnerBuilder b)]) =
      _$RouteGet200ResponseRoutesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteGet200ResponseRoutesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteGet200ResponseRoutesInner> get serializer =>
      _$RouteGet200ResponseRoutesInnerSerializer();
}

class _$RouteGet200ResponseRoutesInnerSerializer
    implements PrimitiveSerializer<RouteGet200ResponseRoutesInner> {
  @override
  final Iterable<Type> types = const [
    RouteGet200ResponseRoutesInner,
    _$RouteGet200ResponseRoutesInner
  ];

  @override
  final String wireName = r'RouteGet200ResponseRoutesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteGet200ResponseRoutesInner object, {
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
            BuiltList, [FullType(RouteGet200ResponseRoutesInnerStepsInner)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteGet200ResponseRoutesInner object, {
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
    required RouteGet200ResponseRoutesInnerBuilder result,
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
                [FullType(RouteGet200ResponseRoutesInnerStepsInner)]),
          ) as BuiltList<RouteGet200ResponseRoutesInnerStepsInner>;
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
  RouteGet200ResponseRoutesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteGet200ResponseRoutesInnerBuilder();
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
