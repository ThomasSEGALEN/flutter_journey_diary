import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<bool> {
  UserCubit(this.firebaseAuth, this.firebaseFirestore) : super(false);

  //final UserRepository userRepository;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  /*
  Future<void> init() async {
    final initState = await userRepository.init();

    emit(initState);
  }
  */

  Future<void> login(String username, String password) async {
    //await userRepository.login(username, password);
    await firebaseAuth.signInWithEmailAndPassword(
        email: username, password: password);

    emit(true);
  }

  Future<bool> signup(String username, String password) async {
    try {
      //await userRepository.signup(username, password);
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

  Future<void> logout() async {
    //await userRepository.logout();
    await firebaseAuth.signOut();

    emit(false);
  }

  Future<void> rateMovie(int movieId, int rating) async {
    //await userRepository.rateMovie(movieId, rating);
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid ?? '')
        .collection('movies')
        .doc(movieId.toString())
        .set({'rating': rating});
  }
}
