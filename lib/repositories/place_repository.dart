<<<<<<< Updated upstream
=======
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
>>>>>>> Stashed changes
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
    var data = collection.value as Map<dynamic, dynamic>;
    data.forEach((key, value) {

    });

    return listPlace;
  }

  Future<bool> savePlace(Place place) async {
    try {
      String? userId = firebaseAuth.currentUser?.uid;
      final storageRef = FirebaseStorage.instance.ref("images");

      int index = 1;
      if (place.images.isNotEmpty) {
        for (var element in place.images) {
          index++;
<<<<<<< Updated upstream
          final mountainImagesRef =
              storageRef.child("$userId/${place.locality}/$index");
=======
          final mountainImagesRef = storageRef.child(
              "$userId/${place.locality}/$index");
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
    } catch (e) {
      return false;
    }
  }
}
=======
    }
    catch (e) {
      return false;
    }
  }
}
>>>>>>> Stashed changes
