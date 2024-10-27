# flowmotion_api.api.CongestionApi

## Load the API package
```dart
import 'package:flowmotion_api/api.dart';
```

All URIs are relative to *https://flowmotion-backend-210524342027.asia-southeast1.run.app*

Method | HTTP request | Description
------------- | ------------- | -------------
[**congestedCameraIdGroupbyGet**](CongestionApi.md#congestedcameraidgroupbyget) | **GET** /congested/{camera_id}/{groupby} | Retrieve congestion duration for a specific camera for a given time range.
[**congestionsGet**](CongestionApi.md#congestionsget) | **GET** /congestions | Retrieve congestion data


# **congestedCameraIdGroupbyGet**
> BuiltList<double> congestedCameraIdGroupbyGet(cameraId, groupby, begin, end, threshold)

Retrieve congestion duration for a specific camera for a given time range.

Returns the total time in seconds (as a float) when the camera was \"congested\" according to a threshold, grouped by hour or day.

### Example
```dart
import 'package:flowmotion_api/api.dart';

final api = FlowmotionApi().getCongestionApi();
final String cameraId = cameraId_example; // String | ID of the camera to retrieve congestion duration for
final String groupby = groupby_example; // String | Group congestion duration by hour or day
final DateTime begin = 2013-10-20T19:20:30+01:00; // DateTime | Inclusive start of the time range (timestamp) to retrieve congestion duration.
final DateTime end = 2013-10-20T19:20:30+01:00; // DateTime | Exclusive end of the time range (timestamp) to retrieve congestion duration.
final double threshold = 3.4; // double | Congestion rating level (between 0 and 1) that is considered \"congested\"

try {
    final response = api.congestedCameraIdGroupbyGet(cameraId, groupby, begin, end, threshold);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CongestionApi->congestedCameraIdGroupbyGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cameraId** | **String**| ID of the camera to retrieve congestion duration for | 
 **groupby** | **String**| Group congestion duration by hour or day | 
 **begin** | **DateTime**| Inclusive start of the time range (timestamp) to retrieve congestion duration. | 
 **end** | **DateTime**| Exclusive end of the time range (timestamp) to retrieve congestion duration. | 
 **threshold** | **double**| Congestion rating level (between 0 and 1) that is considered \"congested\" | [optional] [default to 0.6]

### Return type

**BuiltList&lt;double&gt;**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **congestionsGet**
> BuiltList<Congestion> congestionsGet(cameraId, agg, groupby, begin, end)

Retrieve congestion data

Returns traffic congestion data inferred from traffic cameras. Optionally filter by camera ID, time range, aggregate by time, and group by hour or day. By default, if no time range is specified in `begin`, `end` return only congestions ingested from the latest `updated_on` timestamp.

### Example
```dart
import 'package:flowmotion_api/api.dart';

final api = FlowmotionApi().getCongestionApi();
final String cameraId = cameraId_example; // String | Filter by congestion points by specific camera id.
final String agg = agg_example; // String | Aggregation method applied to congestion rating. By default, no aggregation is performed. Has no effect if `groupby` is not specified.
final String groupby = groupby_example; // String | Group congestion data by hour or day. `agg` must also be specified to supply an aggregation method.
final DateTime begin = 2013-10-20T19:20:30+01:00; // DateTime | Inclusive start of the time range (timestamp) to filter congestion data. If unspecified, defaults to the latest `updated_on` timestamp.
final DateTime end = 2013-10-20T19:20:30+01:00; // DateTime | Exclusive end of the time range (timestamp) to filter congestion data. If unspecified, defaults to the latest `updated_on` timestamp.

try {
    final response = api.congestionsGet(cameraId, agg, groupby, begin, end);
    print(response);
} catch on DioException (e) {
    print('Exception when calling CongestionApi->congestionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cameraId** | **String**| Filter by congestion points by specific camera id. | [optional] 
 **agg** | **String**| Aggregation method applied to congestion rating. By default, no aggregation is performed. Has no effect if `groupby` is not specified. | [optional] [default to 'avg']
 **groupby** | **String**| Group congestion data by hour or day. `agg` must also be specified to supply an aggregation method. | [optional] 
 **begin** | **DateTime**| Inclusive start of the time range (timestamp) to filter congestion data. If unspecified, defaults to the latest `updated_on` timestamp. | [optional] 
 **end** | **DateTime**| Exclusive end of the time range (timestamp) to filter congestion data. If unspecified, defaults to the latest `updated_on` timestamp. | [optional] 

### Return type

[**BuiltList&lt;Congestion&gt;**](Congestion.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

