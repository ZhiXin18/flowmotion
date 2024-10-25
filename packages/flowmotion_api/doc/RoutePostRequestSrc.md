# flowmotion_api.model.RoutePostRequestSrc

## Load the model package
```dart
import 'package:flowmotion_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**kind** | **String** | Specifies if the source is an address or a location | [optional] 
**address** | [**Address**](Address.md) | Required if `kind` is `address`. | [optional] 
**location** | [**Location**](Location.md) | Required if `kind` is `location` | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


