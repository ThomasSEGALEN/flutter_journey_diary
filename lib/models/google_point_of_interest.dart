import 'package:flutter_journey_diary/models/location.dart';
import 'package:flutter_journey_diary/models/to_visit.dart';

class GooglePointOfInterest extends ToVisit {
  String? placeId;
  String? name;
  String? vicinity;
  num? rating;
  int? totalRating;
  List<dynamic>? photos;
  Location? location;

  GooglePointOfInterest({
    required this.placeId,
    required this.name,
    required this.vicinity,
    required this.rating,
    required this.totalRating,
    required this.photos,
    required this.location,
    required super.isPlanned,
  });

  factory GooglePointOfInterest.fromJson(Map<String, dynamic> json) =>
      GooglePointOfInterest(
        placeId: json['place_id'],
        name: json['name'],
        vicinity: json['vicinity'],
        rating: json['rating'],
        totalRating: json['user_ratings_total'],
        photos: json['photos'],
        location: Location(
          latitude: json['geometry']['location']['lat'],
          longitude: json['geometry']['location']['lng'],
        ),
        isPlanned: false,
      );

  @override
  String toString() =>
      'GooglePointOfInterest{placeId: $placeId, name: $name, vicinity: $vicinity, rating: $rating, totalRating: $totalRating, photos: $photos, location: $location, isPlanned: $isPlanned';
}
