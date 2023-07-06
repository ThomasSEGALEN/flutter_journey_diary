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
    List<Place> listPlace = [];
    String? userId = firebaseAuth.currentUser?.uid;
    DatabaseReference ref = firebaseDatabase.ref();

    var collection = (await ref.child("users/$userId/places").get());

    if (collection.value != null) {
      var data = collection.value as Map<dynamic, dynamic>;

      data.forEach((key, value) {
        Place place = Place(
            name: value['name'],
            description: value['description'],
            locality: value['locality']);

        listPlace.add(place);
      });
    }
    final storageRef = firebaseStorage.ref();

    for (var element in listPlace) {
      try {
        List<String> images = [];
        // Récupérer la liste des fichiers dans le dossier "images"
        final mountainImagesRef =
            storageRef.child("users/$userId/places/${element.locality}");
        final ListResult result = await mountainImagesRef.listAll(); //ISSUE

        // Parcourir tous les fichiers
        for (final Reference ref in result.items) {
          // Récupérer l'URL de téléchargement de chaque fichier
          final image = await ref.getDownloadURL(); //ISSUE
          images.add(image);
        }
        element.urls = images;
      } catch (e) {
        log(e.toString());
      }
    }

    return listPlace;
  }

  Future<bool> savePlace(Place place) async {
    try {
      String? userId = firebaseAuth.currentUser?.uid;
      int index = 1;
      final List<File>? imageTable = place.images;

      if (place.images != null) {
        for (var element in imageTable!) {
          index++;
          await firebaseStorage
              .ref()
              .child("users/$userId/places/${place.locality}/$index")
              .putFile(element);
        }
      }

      await firebaseDatabase
          .ref()
          .child('users/$userId/places/${place.locality}')
          .set({
        "name": place.name,
        "description": place.description,
        "locality": place.locality,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePlace(Place place) async {
    try {
      String? userId = firebaseAuth.currentUser?.uid;

      await firebaseStorage
          .ref()
          .child("users/$userId/places/${place.locality}")
          .listAll()
          .then(
        (value) {
          for (var element in value.items) {
            firebaseStorage.ref(element.fullPath).delete();
          }
        },
      );

      await firebaseDatabase
          .ref()
          .child("users/$userId/places/${place.locality}")
          .remove();

      return true;
    } catch (e) {
      log(e.toString());

      return false;
    }
  }
}
