import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_journey_diary/models/place.dart';

class PlaceRepository {
  final FirebaseDatabase database;
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage storage;

  PlaceRepository(this.database, this.firebaseAuth, this.storage);

  Future<bool> savePlace(Place place) async {
    try {
      String? userId = firebaseAuth.currentUser?.uid;
      final storageRef = FirebaseStorage.instance.ref("images");

      Map<String, String> imageMap = {};
      int index = 1;
      if (place.images.isNotEmpty) {
        for (var element in place.images) {
          index++;
          final mountainImagesRef =
              storageRef.child("$userId/${place.locality}/$index");
          mountainImagesRef.putFile(element);
          imageMap.addAll({"images": element.path});
        }
      }
      DatabaseReference ref = FirebaseDatabase.instance.ref();

      ref.child('$userId').push().set({
        "place": {
          "name": place.name,
          "locality": place.locality,
          "description": place.description,
          "images": imageMap
        }
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}
