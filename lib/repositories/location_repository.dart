import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_journey_diary/models/amadeus.dart';
import 'package:flutter_journey_diary/models/location.dart';
import 'package:flutter_journey_diary/models/location_place.dart';

class LocationRepository {
  final Dio dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL'] as String));
  String? token = Amadeus().token;

  Future<List<Location>> fetchLocations(String locationName) async {
    final String? accessToken = token ?? await Amadeus().generateAccessToken();
    late final Response response;

    try {
      response = await dio.get(
        '/cities',
        queryParameters: {
          'keyword': locationName,
          'max': 1, // Selects only the first element
        },
        options: Options(
          headers: {"Authorization": "Bearer $accessToken"},
        ),
      );
    } catch (e) {
      log(e.toString());

      Amadeus().token = null;
      fetchLocations(locationName);
    }

    // List of available cities in the Test API
    final List<String> availableLocations = [
      'bangalore',
      'barcelona',
      'berlin',
      'dallas',
      'london',
      'new york',
      'paris',
      'san francisco',
    ];

    // Check whether the search contains a city from the list
    if (response.statusCode != 200 ||
        !availableLocations.contains(locationName.toLowerCase())) {
      throw Exception();
    }

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
    late final Response response;

    try {
      response = await dio.get(
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
    } catch (e) {
      log(e.toString());

      Amadeus().token = null;
      fetchPlaces(location);
    }

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
