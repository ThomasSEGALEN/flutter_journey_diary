import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_journey_diary/models/google_point_of_interest.dart';
import 'package:flutter_journey_diary/models/location.dart';

class ToVisitRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;
  final FirebaseStorage firebaseStorage;

  ToVisitRepository(
      this.firebaseAuth, this.firebaseDatabase, this.firebaseStorage);

  Future<List<GooglePointOfInterest>> getVisits() async {
    final String? userId = firebaseAuth.currentUser?.uid;
    final DataSnapshot collection =
        await firebaseDatabase.ref().child('users/$userId/visits').get();
    final List<GooglePointOfInterest> visits = [];

    if (collection.value != null) {
      final data = collection.value as Map<Object?, Object?>;

      for (final entry in data.entries) {
        Map<String, dynamic> dataObj = Map<String, dynamic>.from(entry.value as Map);

        final GooglePointOfInterest visit = GooglePointOfInterest(
          placeId: dataObj['placeId'],
          name: dataObj['name'],
          vicinity: dataObj['vicinity'],
          rating: dataObj['rating'],
          totalRating: dataObj['totalRating'],
          photos: dataObj['photos'],
          location: Location(
            latitude: dataObj['location']['latitude'],
            longitude: dataObj['location']['longitude'],
          ),
          isPlanned: dataObj['isPlanned'],
        );

        visits.add(visit);
      }
    }

    return visits;
  }

  Future<void> addToVisits(GooglePointOfInterest visit) async {
    try {
      final String? userId = firebaseAuth.currentUser?.uid;

      visit.isPlanned = true;

      await firebaseDatabase
          .ref()
          .child('users/$userId/visits/${visit.placeId}')
          .set({
        'placeId': visit.placeId,
        'name': visit.name,
        'vicinity': visit.vicinity,
        'rating': visit.rating,
        'totalRating': visit.totalRating,
        'photos': visit.photos,
        'location': {
          'latitude': visit.location?.latitude,
          'longitude': visit.location?.longitude,
        },
        'isPlanned': visit.isPlanned,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> removeFromVisits(GooglePointOfInterest visit) async {
    try {
      final String? userId = firebaseAuth.currentUser?.uid;

      await firebaseDatabase
          .ref()
          .child('users/$userId/visits/${visit.placeId}')
          .remove();

      visit.isPlanned = false;
    } catch (e) {
      log(e.toString());
    }
  }
}
