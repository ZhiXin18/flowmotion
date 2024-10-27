//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:flowmotion_api/src/date_serializer.dart';
import 'package:flowmotion_api/src/model/date.dart';

import 'package:flowmotion_api/src/model/address.dart';
import 'package:flowmotion_api/src/model/camera.dart';
import 'package:flowmotion_api/src/model/congestion.dart';
import 'package:flowmotion_api/src/model/location.dart';
import 'package:flowmotion_api/src/model/rating.dart';
import 'package:flowmotion_api/src/model/route_get200_response.dart';
import 'package:flowmotion_api/src/model/route_get200_response_routes_inner.dart';
import 'package:flowmotion_api/src/model/route_get200_response_routes_inner_steps_inner.dart';
import 'package:flowmotion_api/src/model/route_get_request.dart';
import 'package:flowmotion_api/src/model/route_get_request_dest.dart';
import 'package:flowmotion_api/src/model/route_get_request_src.dart';

part 'serializers.g.dart';

@SerializersFor([
  Address,
  Camera,
  Congestion,
  Location,
  Rating,
  RouteGet200Response,
  RouteGet200ResponseRoutesInner,
  RouteGet200ResponseRoutesInnerStepsInner,
  RouteGetRequest,
  RouteGetRequestDest,
  RouteGetRequestSrc,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Congestion)]),
        () => ListBuilder<Congestion>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(double)]),
        () => ListBuilder<double>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
