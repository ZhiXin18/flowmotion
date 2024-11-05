# flowmotion_api.api.CongestionApi

## Load the API package
```dart
import 'package:flowmotion_api/api.dart';
```

All URIs are relative to *https://flowmotion-backend-210524342027.asia-southeast1.run.app*

Method | HTTP request | Description
------------- | ------------- | -------------
[**congestionsGet**](CongestionApi.md#congestionsget) | **GET** /congestions | Retrieve congestion data


# **congestionsGet**
> BuiltList<Congestion> congestionsGet(cameraId, agg, groupby, begin, end, minRating)

Retrieve congestion data

Returns traffic congestion data inferred from traffic cameras. Optionally filter by camera ID, time range, aggregate by time, and group by hour or day. By default, if no time range is specified in `begin`, `end` return only congestions ingested from the latest `updated_on` timestamp.

### Example
```dart
import 'package:flowmotion_api/api.dart';

final api = FlowmotionApi().getCongestionApi();
final String cameraId = cameraId_example; // String | Filter congestion points by specific camera id.
final String agg = agg_example; // String | Aggregation method applied to congestion rating. By default, no aggregation is performed. Has no effect if `groupby` is not specified.
final String groupby = groupby_example; // String | Group congestion rating by hour or day. `agg` must also be specified to supply an aggregation method.
final DateTime begin = 2013-10-20T19:20:30+01:00; // DateTime | Inclusive start of the time range (timestamp) to filter congestion data. If unspecified, defaults to the latest `updated_on` timestamp.
final DateTime end = 2013-10-20T19:20:30+01:00; // DateTime | Exclusive end of the time range (timestamp) to filter congestion data. If unspecified, defaults to the latest `updated_on` timestamp.
final double minRating = 3.4; // double | Filter congestion points by with congestion rating >= `min_rating`.

try {
    final response = api.congestionsGet(cameraId, agg, groupby, begin, end, minRating);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CongestionApi->congestionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cameraId** | **String**| Filter congestion points by specific camera id. | [optional] 
 **agg** | **String**| Aggregation method applied to congestion rating. By default, no aggregation is performed. Has no effect if `groupby` is not specified. | [optional] 
 **groupby** | **String**| Group congestion rating by hour or day. `agg` must also be specified to supply an aggregation method. | [optional] 
 **begin** | **DateTime**| Inclusive start of the time range (timestamp) to filter congestion data. If unspecified, defaults to the latest `updated_on` timestamp. | [optional] 
 **end** | **DateTime**| Exclusive end of the time range (timestamp) to filter congestion data. If unspecified, defaults to the latest `updated_on` timestamp. | [optional] 
 **minRating** | **double**| Filter congestion points by with congestion rating >= `min_rating`. | [optional] 

### Return type

[**BuiltList&lt;Congestion&gt;**](Congestion.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

