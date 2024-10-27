# flowmotion_api.api.RoutingApi

## Load the API package
```dart
import 'package:flowmotion_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**routeGet**](RoutingApi.md#routeget) | **GET** /route | Retrieve recommended routes between source and destination


# **routeGet**
> RouteGet200Response routeGet(routeGetRequest)

Retrieve recommended routes between source and destination

Returns a list of recommended routes from source to destination, including geometry, duration, distance, and step-by-step instructions.

### Example
```dart
import 'package:flowmotion_api/api.dart';

final api = FlowmotionApi().getRoutingApi();
final RouteGetRequest routeGetRequest = ; // RouteGetRequest | 

try {
    final response = api.routeGet(routeGetRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling RoutingApi->routeGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **routeGetRequest** | [**RouteGetRequest**](RouteGetRequest.md)|  | 

### Return type

[**RouteGet200Response**](RouteGet200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

