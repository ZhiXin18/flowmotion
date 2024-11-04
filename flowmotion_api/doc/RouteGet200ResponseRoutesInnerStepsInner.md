# flowmotion_api.model.RouteGet200ResponseRoutesInnerStepsInner

## Load the model package
```dart
import 'package:flowmotion_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**name** | **String** | Name of the road | 
**duration** | **double** | Estimated duration of the step in seconds | 
**distance** | **double** | Travel distance of the step in meters | 
**geometry** | **String** | Polyline (precision 5) for drawing this step on a map | 
**direction** | **String** | Direction to take for the step | 
**maneuver** | **String** | The type of maneuver to perform | 
**instruction** | **String** | OSRM-style text instructions for this step | 
**congestion** | [**Congestion**](Congestion.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


