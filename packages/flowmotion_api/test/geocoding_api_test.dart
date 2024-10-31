import 'package:test/test.dart';
import 'package:flowmotion_api/flowmotion_api.dart';

/// tests for GeocodingApi
void main() {
  final instance = FlowmotionApi().getGeocodingApi();

  group(GeocodingApi, () {
    // Retrieve location coordinates by postal code
    //
    // Returns the geographical coordinates (latitude and longitude) for a given postal code.
    //
    //Future<Location> geocodePostcodeGet(String postcode) async
    test('test geocodePostcodeGet', () async {
      // TODO
    });
  });
}
