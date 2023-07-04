import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_journey_diary/models/amadeus.dart';
import 'package:flutter_journey_diary/models/location.dart';
import 'package:flutter_journey_diary/models/location_place.dart';

class LocationRepository {
  final Dio dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL'] as String));
  String? token = Amadeus().token;

  Future<Location> fetchLocation(String locationName) async {
    String? accessToken = token ?? await Amadeus().generateAccessToken();
    final response = await dio.get(
      '/cities',
      queryParameters: {
        'keyword': locationName,
        'max': 1,
      },
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );

    // Test API constraints
    final List<String> availableLocations = [
      'Bangalore',
      'Barcelona',
      'Berlin',
      'Dallas',
      'London',
      'New York',
      'Paris',
      'San Francisco',
    ];

    if (response.statusCode != 200 ||
        !availableLocations.contains(locationName)) throw Exception();

    final res = response.data as Map<String, dynamic>;
    final data = res['data'] as List<dynamic>;
    final locationJson = data[0] as Map<String, dynamic>;
    final Location location = Location.fromJson(locationJson);

    return location;
  }

  Future<List<Location>> fetchLocations(String locationName) async {
    String? accessToken = token ?? await Amadeus().generateAccessToken();
    final response = await dio.get(
      '/cities',
      queryParameters: {
        'keyword': locationName,
        'max': 10,
      },
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );

    if (response.statusCode != 200) throw Exception();

    final List<Location> locations = [];
    final res = response.data as Map<String, dynamic>;
    final data = res['data'] as List<dynamic>;

    for (Map<String, dynamic> locationJson in data) {
      final Location location = Location.fromJson(locationJson);
      locations.add(location);
    }

    return locations;
  }

  Future<List<LocationPlace>> fetchPlaces(Location location) async {
    String? accessToken = token ?? await Amadeus().generateAccessToken();
    final response = await dio.get(
      '/pois',
      queryParameters: {
        'latitude': location.latitude,
        'longitude': location.longitude,
        'page': 1,
      },
      options: Options(
        headers: {"Authorization": "Bearer $accessToken"},
      ),
    );

    if (response.statusCode != 200) throw Exception();

    final List<LocationPlace> places = [];
    final res = response.data as Map<String, dynamic>;
    final data = res['data'] as List<dynamic>;

    for (Map<String, dynamic> placeJson in data) {
      final LocationPlace place = LocationPlace.fromJson(placeJson);
      places.add(place);
    }

    return places;
  }
}
