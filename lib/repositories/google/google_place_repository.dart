import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_journey_diary/models/google_place.dart';
import 'package:flutter_journey_diary/models/google_point_of_interest.dart';
import 'package:flutter_journey_diary/models/google_prediction.dart';

class GooglePlaceRepository {
  final Dio dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL'] as String));
  final String _apiKey = dotenv.env['GOOGLE_TOKEN'] as String;

  Future<List<GooglePrediction>> fetchPlaces(String placeName) async {
    final Response response = await dio.get(
      '/place/autocomplete/json',
      queryParameters: {
        'key': _apiKey,
        'input': placeName,
      },
    );

    if (response.statusCode != 200) throw Exception();

    final List<GooglePrediction> predictions = [];
    final data = response.data as Map<String, dynamic>;
    final results = data['predictions'] as List<dynamic>;

    for (Map<String, dynamic> predictionJson in results) {
      final GooglePrediction prediction =
          GooglePrediction.fromJson(predictionJson);

      predictions.add(prediction);
    }

    return predictions;
  }

  Future<GooglePlace> fetchPlace(String placeId) async {
    final Response response = await dio.get(
      '/place/details/json',
      queryParameters: {
        'key': _apiKey,
        'place_id': placeId,
      },
    );

    if (response.statusCode != 200) throw Exception();

    final data = response.data as Map<String, dynamic>;
    final placeJson = data['result'] as Map<String, dynamic>;
    final GooglePlace place = GooglePlace.fromJson(placeJson);

    return place;
  }

  Future<List<GooglePointOfInterest>> fetchPointsOfInterest(
      GooglePlace place) async {
    final Response response = await dio.get(
      '/place/nearbysearch/json',
      queryParameters: {
        'key': _apiKey,
        'location':
            "${place.location!['latitude']},${place.location!['longitude']}",
        'radius': 5000,
        'keyword': 'point of interest',
      },
    );

    if (response.statusCode != 200) throw Exception();

    final List<GooglePointOfInterest> pointsOfInterest = [];
    final data = response.data as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;

    for (Map<String, dynamic> pointOfInterestJson in results) {
      final GooglePointOfInterest pointOfInterest =
          GooglePointOfInterest.fromJson(pointOfInterestJson);

      pointsOfInterest.add(pointOfInterest);
    }

    return pointsOfInterest;
  }

  String getImageUrl(String photoReference) {
    if (photoReference.isEmpty) return '';

    String baseUrl = dotenv.env['BASE_URL'] as String;
    String suffixUrl = '/place/photo?key=$_apiKey&photoreference=$photoReference&maxwidth=400';
    String fullUrl = '$baseUrl$suffixUrl';

    return fullUrl;
  }
}
