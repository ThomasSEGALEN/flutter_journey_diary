import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_journey_diary/models/place.dart';

class PlaceRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseDatabase firebaseDatabase;
  final FirebaseStorage firebaseStorage;

  PlaceRepository(
      this.firebaseAuth, this.firebaseDatabase, this.firebaseStorage);

  Future<List<Place>> getPlaces() async {
    final String? userId = firebaseAuth.currentUser?.uid;
    final DataSnapshot collection =
        await firebaseDatabase.ref().child('users/$userId/places').get();
    late final List<Place> places = [];

    if (collection.value != null) {
      final data = collection.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        Place place = Place(
          id: value['id'],
          name: value['name'],
          description: value['description'],
          locality: value['locality'],
        );

        places.add(place);
      });
    }

    for (Place place in places) {
      try {
        final ListResult result = await firebaseStorage
            .ref()
            .child('users/$userId/places/${place.id}')
            .listAll();
        late final List<String> images = [];

        for (final Reference reference in result.items) {
          final String image = await reference.getDownloadURL();

          images.add(image);
        }

        place.urls = images;
      } catch (e) {
        log(e.toString());
      }
    }

    return places;
  }

  Future<void> savePlace(Place place) async {
    try {
      final String? userId = firebaseAuth.currentUser?.uid;
      int index = 1;
      final List<File>? imageTable = place.images;

      if (place.images != null) {
        for (var element in imageTable!) {
          index++;

          await firebaseStorage
              .ref()
              .child(
                  'users/$userId/places/${place.id}/$index')
              .putFile(element);
        }
      }

      await firebaseDatabase
          .ref()
          .child('users/$userId/places/${place.id}')
          .set({
        'id': place.id,
        'name': place.name,
        'description': place.description,
        'locality': place.locality,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deletePlace(Place place) async {
    try {
      final String? userId = firebaseAuth.currentUser?.uid;

      await firebaseStorage
          .ref()
          .child('users/$userId/places/${place.id}')
          .listAll()
          .then((value) {
        for (var element in value.items) {
          firebaseStorage.ref(element.fullPath).delete();
        }
      });

      await firebaseDatabase
          .ref()
          .child('users/$userId/places/${place.id}')
          .remove();
    } catch (e) {
      log(e.toString());
    }
  }
}
