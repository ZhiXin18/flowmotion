import 'package:test/test.dart';
import 'package:flowmotion_api/flowmotion_api.dart';

/// tests for CongestionApi
void main() {
  final instance = FlowmotionApi().getCongestionApi();

  group(CongestionApi, () {
    // Retrieve congestion duration for a specific camera
    //
    // Returns the total time in seconds (as a float) when the camera was \"congested\" according to a threshold, grouped by hour or day.
    //
    //Future<BuiltList<double>> congestedCameraIdGroupbyGet(String cameraId, String groupby, { double threshold }) async
    test('test congestedCameraIdGroupbyGet', () async {
      // TODO
    });

    // Retrieve congestion data
    //
    // Returns congestion data camera ID. Optionally filter by camera ID, time range, aggregate by time, and group by hour or day.
    //
    //Future<BuiltList<Congestion>> congestionsGet({ String cameraId, String agg, String groupby, DateTime begin, DateTime end }) async
    test('test congestionsGet', () async {
      // TODO
    });
  });
}
