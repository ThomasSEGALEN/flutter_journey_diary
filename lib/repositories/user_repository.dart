import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  UserRepository(this.firebaseAuth, this.firebaseFirestore);

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  Future<bool> init() async {
    return firebaseAuth.currentUser != null;
  }

  Future<bool> login(String username, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: username, password: password);

      return true;
    } catch (e) {
      log(e.toString());

      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: username,
        password: password,
      );

      return true;
    } catch (e) {
      log(e.toString());

      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
    }

    return false;
  }

  Future<bool> resetPassword(String username) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: username);

      return true;
    } catch (e) {
      log(e.toString());

      return false;
    }
  }
}
