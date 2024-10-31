# flowmotion_api.api.GeocodingApi

## Load the API package
```dart
import 'package:flowmotion_api/api.dart';
```

All URIs are relative to *https://flowmotion-backend-210524342027.asia-southeast1.run.app*

Method | HTTP request | Description
------------- | ------------- | -------------
[**geocodePostcodeGet**](GeocodingApi.md#geocodepostcodeget) | **GET** /geocode/{postcode} | Retrieve location coordinates by postal code


# **geocodePostcodeGet**
> Location geocodePostcodeGet(postcode)

Retrieve location coordinates by postal code

Returns the geographical coordinates (latitude and longitude) for a given postal code.

### Example
```dart
import 'package:flowmotion_api/api.dart';

final api = FlowmotionApi().getGeocodingApi();
final String postcode = postcode_example; // String | Postal code to retrieve location coordinates for.

try {
    final response = api.geocodePostcodeGet(postcode);
    print(response);
} catch on DioException (e) {
    print('Exception when calling GeocodingApi->geocodePostcodeGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **postcode** | **String**| Postal code to retrieve location coordinates for. | 

### Return type

[**Location**](Location.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

