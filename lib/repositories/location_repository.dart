import 'package:dio/dio.dart';
import 'package:flutter_journey_diary/models/amadeus.dart';
import 'package:flutter_journey_diary/models/location.dart';

class LocationRepository {
  final dio = Dio(BaseOptions(baseUrl: 'https://test.api.amadeus.com/v1'));
  String? token = Amadeus().token;

  Future<List<Location>> fetchLocations(String locationName) async {
    String? accessToken = token ?? await Amadeus().generateAccessToken();
    final response = await dio.get(
        '/reference-data/locations/cities?keyword=$locationName&max=20',
        options: Options(headers: {"Authorization": "Bearer $accessToken"}));

    if (response.statusCode == 200) {
      final List<Location> locations = [];
      final res = response.data as Map<String, dynamic>;
      final data = res['data'] as List<dynamic>;

      for (Map<String, dynamic> locationJson in data) {
        if (locationJson['geoCode']['latitude'] == null ||
            locationJson['geoCode']['longitude'] == null) continue;

        final location = Location.fromJson(locationJson);
        locations.add(location);
      }

      return locations;
    } else {
      throw Exception();
    }
  }
}
