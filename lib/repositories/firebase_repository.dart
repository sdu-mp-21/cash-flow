import 'dart:async';
import 'package:final_project/models/models.dart' as Models;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRepository {
  late FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

  // for developing purposes, todo: delete initialization and make it 'late'
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

  Future createAccount(Models.Account account) async {
    await _firebaseStore.collection(_user.email).add(account.toJson());
  }

  Future<List<Models.Account>> getAccounts() async {
    final snapshot = await _firebaseStore.collection(_user.email).get();
    final List<DocumentSnapshot> documents = snapshot.docs;
    List<Models.Account> accounts = [];
    documents.forEach((doc) {
      final data = doc.data();
      accounts.add(Models.Account.fromJson(
          doc.id, data as Map<String, dynamic>)); // convert Object to Map
    });
    return accounts;
  }

  static const keyTransactionsList = 'transactions';

  Future createTransaction(
      Models.Account account, Models.Transaction transaction) async {
    transaction.setAccountId = account.account_id;
    await _firebaseStore
        .collection(_user.email)
        .doc(account.account_id)
        .update({keyTransactionsList: transaction.toJson()}); // not map, array
  }
}
