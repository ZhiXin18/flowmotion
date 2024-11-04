import 'package:test/test.dart';
import 'package:flowmotion_api/flowmotion_api.dart';

// tests for RoutePostRequestDest
void main() {
  final instance = RoutePostRequestDestBuilder();
  // TODO add properties to the builder and call build()

  group(RoutePostRequestDest, () {
    // Specifies if the destination is an address or a location
    // String kind
    test('to test the property `kind`', () async {
      // TODO
    });

    // Required if `kind` is `address`.
    // Address address
    test('to test the property `address`', () async {
      // TODO
    });

    // Required if `kind` is `location`
    // Location location
    test('to test the property `location`', () async {
      // TODO
    });
  });
}
