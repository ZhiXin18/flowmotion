import 'package:test/test.dart';
import 'package:flowmotion_api/flowmotion_api.dart';

/// tests for RoutingApi
void main() {
  final instance = FlowmotionApi().getRoutingApi();

  group(RoutingApi, () {
    // Retrieve recommended routes between source and destination
    //
    // Returns a list of recommended routes from source to destination, including geometry, duration, distance, and step-by-step instructions.
    //
    //Future<RoutePost200Response> routePost(RoutePostRequest routePostRequest) async
    test('test routePost', () async {
      // TODO
    });
  });
}
