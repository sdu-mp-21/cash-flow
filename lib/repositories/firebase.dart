import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/models/models.dart' as Models;

class FirebaseRepository {
  late FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Models.User _user = Models.User('dias@mail.com', 'qwerty');

  Models.User get user => _user;

  Future<bool> loginUser(Models.User u) async {
    try {
      final UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: u.email,
        password: u.password,
      );
      u.setID = credential.user!.uid;
      _user = u;
    } catch (error) {
      print(error);
      return false;
    }
    return true;
  }

  Future<bool> registerUser(Models.User u) async {
    try {
      _firebaseAuth.createUserWithEmailAndPassword(
        email: u.email,
        password: u.password,
      );
    } catch (error) {
      print(error);
      return false;
    }
    return true;
  }
}
