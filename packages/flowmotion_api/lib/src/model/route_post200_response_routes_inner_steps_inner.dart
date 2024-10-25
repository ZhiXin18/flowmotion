//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:flowmotion_api/src/model/congestion.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_post200_response_routes_inner_steps_inner.g.dart';

/// RoutePost200ResponseRoutesInnerStepsInner
///
/// Properties:
/// * [name] - Name of the road
/// * [duration] - Estimated duration of the step in seconds
/// * [distance] - Travel distance of the step in meters
/// * [geometry] - Polyline (precision 5) for drawing this step on a map
/// * [direction] - Direction to take for the step
/// * [maneuver] - The type of maneuver to perform
/// * [instruction] - OSRM-style text instructions for this step
/// * [congestion] - Information about congestion, if applicable
@BuiltValue()
abstract class RoutePost200ResponseRoutesInnerStepsInner
    implements
        Built<RoutePost200ResponseRoutesInnerStepsInner,
            RoutePost200ResponseRoutesInnerStepsInnerBuilder> {
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
  RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum? get direction;
  // enum directionEnum {  uturn,  sharp right,  right,  slight right,  straight,  slight left,  left,  sharp left,  };

  /// The type of maneuver to perform
  @BuiltValueField(wireName: r'maneuver')
  RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum? get maneuver;
  // enum maneuverEnum {  turn,  new name,  depart,  arrive,  merge,  on ramp,  off ramp,  fork,  end of road,  use lane,  continue,  roundabout,  rotary,  roundabout turn,  notification,  };

  /// OSRM-style text instructions for this step
  @BuiltValueField(wireName: r'instruction')
  String? get instruction;

  /// Information about congestion, if applicable
  @BuiltValueField(wireName: r'congestion')
  Congestion? get congestion;

  RoutePost200ResponseRoutesInnerStepsInner._();

  factory RoutePost200ResponseRoutesInnerStepsInner(
          [void updates(RoutePost200ResponseRoutesInnerStepsInnerBuilder b)]) =
      _$RoutePost200ResponseRoutesInnerStepsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoutePost200ResponseRoutesInnerStepsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoutePost200ResponseRoutesInnerStepsInner> get serializer =>
      _$RoutePost200ResponseRoutesInnerStepsInnerSerializer();
}

class _$RoutePost200ResponseRoutesInnerStepsInnerSerializer
    implements PrimitiveSerializer<RoutePost200ResponseRoutesInnerStepsInner> {
  @override
  final Iterable<Type> types = const [
    RoutePost200ResponseRoutesInnerStepsInner,
    _$RoutePost200ResponseRoutesInnerStepsInner
  ];

  @override
  final String wireName = r'RoutePost200ResponseRoutesInnerStepsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoutePost200ResponseRoutesInnerStepsInner object, {
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
            RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum),
      );
    }
    if (object.maneuver != null) {
      yield r'maneuver';
      yield serializers.serialize(
        object.maneuver,
        specifiedType: const FullType(
            RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum),
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
        specifiedType: const FullType(Congestion),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RoutePost200ResponseRoutesInnerStepsInner object, {
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
    required RoutePost200ResponseRoutesInnerStepsInnerBuilder result,
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
                RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum),
          ) as RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum;
          result.direction = valueDes;
          break;
        case r'maneuver':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(
                RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum),
          ) as RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum;
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
            specifiedType: const FullType(Congestion),
          ) as Congestion;
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
  RoutePost200ResponseRoutesInnerStepsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoutePost200ResponseRoutesInnerStepsInnerBuilder();
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

class RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum extends EnumClass {
  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'uturn')
  static const RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum uturn =
      _$routePost200ResponseRoutesInnerStepsInnerDirectionEnum_uturn;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'sharp right')
  static const RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum
      sharpRight =
      _$routePost200ResponseRoutesInnerStepsInnerDirectionEnum_sharpRight;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'right')
  static const RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum right =
      _$routePost200ResponseRoutesInnerStepsInnerDirectionEnum_right;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'slight right')
  static const RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum
      slightRight =
      _$routePost200ResponseRoutesInnerStepsInnerDirectionEnum_slightRight;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'straight')
  static const RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum straight =
      _$routePost200ResponseRoutesInnerStepsInnerDirectionEnum_straight;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'slight left')
  static const RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum
      slightLeft =
      _$routePost200ResponseRoutesInnerStepsInnerDirectionEnum_slightLeft;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'left')
  static const RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum left =
      _$routePost200ResponseRoutesInnerStepsInnerDirectionEnum_left;

  /// Direction to take for the step
  @BuiltValueEnumConst(wireName: r'sharp left')
  static const RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum
      sharpLeft =
      _$routePost200ResponseRoutesInnerStepsInnerDirectionEnum_sharpLeft;

  static Serializer<RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum>
      get serializer =>
          _$routePost200ResponseRoutesInnerStepsInnerDirectionEnumSerializer;

  const RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum._(String name)
      : super(name);

  static BuiltSet<RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum>
      get values =>
          _$routePost200ResponseRoutesInnerStepsInnerDirectionEnumValues;
  static RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum valueOf(
          String name) =>
      _$routePost200ResponseRoutesInnerStepsInnerDirectionEnumValueOf(name);
}

class RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum extends EnumClass {
  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'turn')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum turn =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_turn;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'new name')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum newName =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_newName;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'depart')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum depart =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_depart;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'arrive')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum arrive =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_arrive;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'merge')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum merge =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_merge;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'on ramp')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum onRamp =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_onRamp;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'off ramp')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum offRamp =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_offRamp;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'fork')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum fork =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_fork;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'end of road')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum endOfRoad =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_endOfRoad;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'use lane')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum useLane =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_useLane;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'continue')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum continue_ =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_continue_;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'roundabout')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum
      roundabout =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_roundabout;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'rotary')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum rotary =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_rotary;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'roundabout turn')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum
      roundaboutTurn =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_roundaboutTurn;

  /// The type of maneuver to perform
  @BuiltValueEnumConst(wireName: r'notification')
  static const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum
      notification =
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnum_notification;

  static Serializer<RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum>
      get serializer =>
          _$routePost200ResponseRoutesInnerStepsInnerManeuverEnumSerializer;

  const RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum._(String name)
      : super(name);

  static BuiltSet<RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum>
      get values =>
          _$routePost200ResponseRoutesInnerStepsInnerManeuverEnumValues;
  static RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum valueOf(
          String name) =>
      _$routePost200ResponseRoutesInnerStepsInnerManeuverEnumValueOf(name);
}
