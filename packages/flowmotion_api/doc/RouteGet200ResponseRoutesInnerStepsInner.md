# flowmotion_api.model.RouteGet200ResponseRoutesInnerStepsInner

## Load the model package
```dart
import 'package:flowmotion_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** | Name of the road | [optional] 
**duration** | **double** | Estimated duration of the step in seconds | [optional] 
**distance** | **double** | Travel distance of the step in meters | [optional] 
**geometry** | **String** | Polyline (precision 5) for drawing this step on a map | [optional] 
**direction** | **String** | Direction to take for the step | [optional] 
**maneuver** | **String** | The type of maneuver to perform | [optional] 
**instruction** | **String** | OSRM-style text instructions for this step | [optional] 
**congestion** | [**Congestion**](Congestion.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


