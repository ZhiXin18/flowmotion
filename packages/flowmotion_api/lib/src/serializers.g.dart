// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (new Serializers().toBuilder()
      ..add(Address.serializer)
      ..add(Camera.serializer)
      ..add(Congestion.serializer)
      ..add(Error.serializer)
      ..add(Location.serializer)
      ..add(Rating.serializer)
      ..add(RoutePost200Response.serializer)
      ..add(RoutePost200ResponseRoutesInner.serializer)
      ..add(RoutePost200ResponseRoutesInnerStepsInner.serializer)
      ..add(RoutePost200ResponseRoutesInnerStepsInnerDirectionEnum.serializer)
      ..add(RoutePost200ResponseRoutesInnerStepsInnerManeuverEnum.serializer)
      ..add(RoutePostRequest.serializer)
      ..add(RoutePostRequestDest.serializer)
      ..add(RoutePostRequestDestKindEnum.serializer)
      ..add(RoutePostRequestSrc.serializer)
      ..add(RoutePostRequestSrcKindEnum.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(RoutePost200ResponseRoutesInner)]),
          () => new ListBuilder<RoutePost200ResponseRoutesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(RoutePost200ResponseRoutesInnerStepsInner)
          ]),
          () => new ListBuilder<RoutePost200ResponseRoutesInnerStepsInner>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
