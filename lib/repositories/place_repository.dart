import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_journey_diary/models/place.dart';
import 'package:flutter_journey_diary/repositories/user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';


class PlaceRepository {
  final FirebaseDatabase database;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage storage;

  PlaceRepository(this.database, this.firebaseAuth, this.storage);

  Future<bool> savePlace(Place place) async {
    try {
      String? userId = firebaseAuth.currentUser?.uid;
      final storageRef = FirebaseStorage.instance.ref();

      Map<String, String> imageMap = {};
      place.images.forEach((element) {
        final mountainImagesRef = storageRef.child("$userId/${element.path}");
        mountainImagesRef.putFile(element);
        imageMap.addAll({"images": element.path});
      });
      final firebaseApp = Firebase.app();
      final rtdb = FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: 'https://flutter-journey-diary-default-rtdb.europe-west1.firebasedatabase.app');
      DatabaseReference ref = FirebaseDatabase.instance.ref("https://flutter-journey-diary-default-rtdb.europe-west1.firebasedatabase.app/$userId");
      await ref.set(
          {
            "place": {
              "name": place.name,
              "locality": place.locality,
              "description": place.description,
              "images": imageMap
            }
          }
      );
      return true;
    }
    catch(e) {
      return false;
    }
  }

}