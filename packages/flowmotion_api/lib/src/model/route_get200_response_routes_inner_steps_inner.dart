//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:flowmotion_api/src/model/congestion.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_get200_response_routes_inner_steps_inner.g.dart';

/// RouteGet200ResponseRoutesInnerStepsInner
///
/// Properties:
/// * [name] - Name of the road
/// * [duration] - Estimated duration of the step in seconds
/// * [distance] - Travel distance of the step in meters
/// * [geometry] - Polyline (precision 5) for drawing this step on a map
/// * [direction] - Direction to take for the step
/// * [maneuver] - The type of maneuver to perform
/// * [instruction] - OSRM-style text instructions for this step
/// * [congestion]
@BuiltValue()
abstract class RouteGet200ResponseRoutesInnerStepsInner
    implements
        Built<RouteGet200ResponseRoutesInnerStepsInner,
            RouteGet200ResponseRoutesInnerStepsInnerBuilder> {
  /// Name of the road
  @BuiltValueField(wireName: r'name')
  String? get name;

  /// Estimated duration of the step in seconds
  @BuiltValueField(wireName: r'duration')
  double? get duration;

  /// Travel distance of the step in meters
  @BuiltValueField(wireName: r'distance')
  double? get distance;

  /// Polyline (precision 5) for drawing this step on a map
  @BuiltValueField(wireName: r'geometry')
  String? get geometry;

  /// Direction to take for the step
  @BuiltValueField(wireName: r'direction')
  RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum? get direction;
  // enum directionEnum {  uturn,  sharp right,  right,  slight right,  straight,  slight left,  left,  sharp left,  };

  /// The type of maneuver to perform
  @BuiltValueField(wireName: r'maneuver')
  RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum? get maneuver;
  // enum maneuverEnum {  turn,  new name,  depart,  arrive,  merge,  on ramp,  off ramp,  fork,  end of road,  use lane,  continue,  roundabout,  rotary,  roundabout turn,  notification,  };

  /// OSRM-style text instructions for this step
  @BuiltValueField(wireName: r'instruction')
  String? get instruction;

  @BuiltValueField(wireName: r'congestion')
  Congestion? get congestion;

  RouteGet200ResponseRoutesInnerStepsInner._();

  factory RouteGet200ResponseRoutesInnerStepsInner(
          [void updates(RouteGet200ResponseRoutesInnerStepsInnerBuilder b)]) =
      _$RouteGet200ResponseRoutesInnerStepsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteGet200ResponseRoutesInnerStepsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteGet200ResponseRoutesInnerStepsInner> get serializer =>
      _$RouteGet200ResponseRoutesInnerStepsInnerSerializer();
}

class _$RouteGet200ResponseRoutesInnerStepsInnerSerializer
    implements PrimitiveSerializer<RouteGet200ResponseRoutesInnerStepsInner> {
  @override
  final Iterable<Type> types = const [
    RouteGet200ResponseRoutesInnerStepsInner,
    _$RouteGet200ResponseRoutesInnerStepsInner
  ];

  @override
  final String wireName = r'RouteGet200ResponseRoutesInnerStepsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteGet200ResponseRoutesInnerStepsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.name != null) {
      yield r'name';
      yield serializers.serialize(
        object.name,
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
    if (object.geometry != null) {
      yield r'geometry';
      yield serializers.serialize(
        object.geometry,
        specifiedType: const FullType(String),
      );
    }
    if (object.direction != null) {
      yield r'direction';
      yield serializers.serialize(
        object.direction,
        specifiedType: const FullType(
            RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum),
      );
    }
    if (object.maneuver != null) {
      yield r'maneuver';
      yield serializers.serialize(
        object.maneuver,
        specifiedType: const FullType(
            RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum),
      );
    }
    if (object.instruction != null) {
      yield r'instruction';
      yield serializers.serialize(
        object.instruction,
        specifiedType: const FullType(String),
      );
    }
    if (object.congestion != null) {
      yield r'congestion';
      yield serializers.serialize(
        object.congestion,
        specifiedType: const FullType.nullable(Congestion),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteGet200ResponseRoutesInnerStepsInner object, {
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
    required RouteGet200ResponseRoutesInnerStepsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
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
        case r'geometry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.geometry = valueDes;
          break;
        case r'direction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum),
          ) as RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum;
          result.direction = valueDes;
          break;
        case r'maneuver':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum),
          ) as RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum;
          result.maneuver = valueDes;
          break;
        case r'instruction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.instruction = valueDes;
          break;
        case r'congestion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Congestion),
          ) as Congestion?;
          if (valueDes == null) continue;
          result.congestion.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteGet200ResponseRoutesInnerStepsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteGet200ResponseRoutesInnerStepsInnerBuilder();
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

class RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum extends EnumClass {
  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'uturn')
  static const RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum uturn =
      _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnum_uturn;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'sharp right')
  static const RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum
      sharpRight =
      _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnum_sharpRight;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'right')
  static const RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum right =
      _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnum_right;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'slight right')
  static const RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum
      slightRight =
      _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnum_slightRight;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'straight')
  static const RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum straight =
      _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnum_straight;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'slight left')
  static const RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum
      slightLeft =
      _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnum_slightLeft;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'left')
  static const RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum left =
      _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnum_left;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'sharp left')
  static const RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum sharpLeft =
      _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnum_sharpLeft;

  static Serializer<RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum>
      get serializer =>
          _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnumSerializer;

  const RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum._(String name)
      : super(name);

  static BuiltSet<RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum>
      get values =>
          _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnumValues;
  static RouteGet200ResponseRoutesInnerStepsInnerDirectionEnum valueOf(
          String name) =>
      _$routeGet200ResponseRoutesInnerStepsInnerDirectionEnumValueOf(name);
}

class RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum extends EnumClass {
  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'turn')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum turn =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_turn;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'new name')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum newName =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_newName;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'depart')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum depart =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_depart;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'arrive')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum arrive =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_arrive;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'merge')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum merge =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_merge;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'on ramp')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum onRamp =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_onRamp;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'off ramp')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum offRamp =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_offRamp;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'fork')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum fork =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_fork;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'end of road')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum endOfRoad =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_endOfRoad;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'use lane')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum useLane =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_useLane;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'continue')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum continue_ =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_continue_;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'roundabout')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum roundabout =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_roundabout;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'rotary')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum rotary =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_rotary;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'roundabout turn')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum
      roundaboutTurn =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_roundaboutTurn;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'notification')
  static const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum
      notification =
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnum_notification;

  static Serializer<RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum>
      get serializer =>
          _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnumSerializer;

  const RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum._(String name)
      : super(name);

  static BuiltSet<RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum>
      get values =>
          _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnumValues;
  static RouteGet200ResponseRoutesInnerStepsInnerManeuverEnum valueOf(
          String name) =>
      _$routeGet200ResponseRoutesInnerStepsInnerManeuverEnumValueOf(name);
}
