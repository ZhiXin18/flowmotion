//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:built_collection/built_collection.dart';
import 'package:flowmotion_api/src/api_util.dart';
import 'package:flowmotion_api/src/model/congestion.dart';
import 'package:flowmotion_api/src/model/error.dart';

class CongestionApi {
  final Dio _dio;

  final Serializers _serializers;

  const CongestionApi(this._dio, this._serializers);

  /// Retrieve congestion data
  /// Returns traffic congestion data inferred from traffic cameras. Optionally filter by camera ID, time range, aggregate by time, and group by hour or day. Aggregation will perform requested aggregation on &#x60;rating.value&#x60; and set &#x60;rating.rated_on&#x60; timestamp to align with groups. By default, if no time range is specified in &#x60;begin&#x60;, &#x60;end&#x60; return only congestions ingested from the latest &#x60;updated_on&#x60; timestamp.
  ///
  /// Parameters:
  /// * [cameraId] - Filter congestion points by specific camera id.
  /// * [agg] - Aggregation method applied to congestion rating. By default, no aggregation is performed. Has no effect if `groupby` is not specified.
  /// * [groupby] - Group congestion rating by hour or day. `agg` must also be specified to supply an aggregation method.
  /// * [begin] - Inclusive start of the time range (timestamp) to filter congestion data. If unspecified, defaults to the latest `updated_on` timestamp.
  /// * [end] - Exclusive end of the time range (timestamp) to filter congestion data. If unspecified, defaults to the latest `updated_on` timestamp.
  /// * [minRating] - Filter congestion points by with congestion rating >= `min_rating`.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [BuiltList<Congestion>] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<BuiltList<Congestion>>> congestionsGet({
    String? cameraId,
    String? agg,
    String? groupby,
    DateTime? begin,
    DateTime? end,
    double? minRating,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/congestions';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (cameraId != null)
        r'camera_id': encodeQueryParameter(
            _serializers, cameraId, const FullType(String)),
      if (agg != null)
        r'agg': encodeQueryParameter(_serializers, agg, const FullType(String)),
      if (groupby != null)
        r'groupby':
            encodeQueryParameter(_serializers, groupby, const FullType(String)),
      if (begin != null)
        r'begin':
            encodeQueryParameter(_serializers, begin, const FullType(DateTime)),
      if (end != null)
        r'end':
            encodeQueryParameter(_serializers, end, const FullType(DateTime)),
      if (minRating != null)
        r'min_rating': encodeQueryParameter(
            _serializers, minRating, const FullType(double)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    BuiltList<Congestion>? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null
          ? null
          : _serializers.deserialize(
              rawResponse,
              specifiedType: const FullType(BuiltList, [FullType(Congestion)]),
            ) as BuiltList<Congestion>;
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<BuiltList<Congestion>>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }
}
