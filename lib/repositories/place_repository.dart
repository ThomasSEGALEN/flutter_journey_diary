import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_journey_diary/models/place.dart';

class PlaceRepository {
  final FirebaseDatabase database;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage storage;

  PlaceRepository(this.database, this.firebaseAuth, this.storage);

  Future<List<Place>> getPlaces() async {

    List<Place> listPlace = [];
    String? userId = firebaseAuth.currentUser?.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    var collection = (await ref.child("$userId").get());

    if(collection.value != null) {
      var data = collection.value as Map<dynamic, dynamic>;
      data.forEach((key, value) async {
        data = value as Map<dynamic, dynamic>;
        data.forEach((key2, value2) {
          var data2 = value2 as Map<dynamic, dynamic>;
          Place place = Place(locality: "", name: "");
          data2.forEach((key3, value3) {
            if (key3 == "locality") {
              place.locality = value3;
            }
            else if (key3 == "name") {
              place.name = value3;
            }
            else if (key3 == "description") {
              place.description = value3;
            }
          });
          listPlace.add(place);
        });
      });
    }
    final storageRef = FirebaseStorage.instance.ref("images");

    for (var element in listPlace){
      try {
        List<String> images = [];
        // Récupérer la liste des fichiers dans le dossier "images"
        print(element);
        final mountainImagesRef =
          storageRef.child("$userId/${element.locality}");
        final ListResult result = await mountainImagesRef.listAll();

        // Parcourir tous les fichiers
        for (final Reference ref in result.items) {
          // Récupérer l'URL de téléchargement de chaque fichier

          final image = await ref.getDownloadURL();
          images.add(image);
        }
        element.urls = images;
      } catch (e) {
        print('Une erreur s\'est produite lors de la récupération des images : $e');
      }
    }
    print(listPlace.toString());
    return listPlace;
  }

  Future<bool> savePlace(Place place) async {
    try {
      String? userId = firebaseAuth.currentUser?.uid;
      final storageRef = FirebaseStorage.instance.ref("images");

      int index = 1;
      final List<File>? imageTable = place.images;
      if (place.images != null) {
        for (var element in imageTable!) {
          index++;
          final mountainImagesRef =
              storageRef.child("$userId/${place.locality}/$index");
          mountainImagesRef.putFile(element);
        }
      }
      DatabaseReference ref = FirebaseDatabase.instance.ref();

      ref.child('$userId').push().set({
        "place": {
          "name": place.name,
          "locality": place.locality,
          "description": place.description,
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
