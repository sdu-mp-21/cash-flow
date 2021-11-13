import 'dart:async';
import 'dart:convert';
import 'package:final_project/models/models.dart' as Models;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/repositories/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseRepository extends Repository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;
  final CollectionReference collectionUsersReference =
      FirebaseFirestore.instance.collection(collectionUsers);

  static const collectionUsers = 'users';
  static const collectionAccounts = 'accounts';
  static const collectionTransactions = 'transactions';
  static const collectionCategories = 'categories';

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
      final UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: u.email,
        password: u.password,
      );
      u.setID = credential.user!.uid;
      _user = u;

      await createAccount(Models.Account('Account1', 0));
      await createCategory(Models.Category('Health'));
    } catch (error) {
      print(error);
      return false;
    }
    return true;
  }

  //---accounts---

  Future createAccount(Models.Account account) async {
    final docRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts)
        .doc();

    account.setAccountId = docRef.id;
    await docRef.set(account.toJson());
  }

  Future<List<Models.Account>> getAccounts() async {
    final colRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts);

    final documents = (await colRef.get()).docs;
    return documents.map((doc) => Models.Account.fromJson(doc.data())).toList();
  }

  //---transactions---

  Future createTransaction(Models.Transaction transaction,
      Models.Account account, Models.Category category) async {
    final DocumentReference docRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions)
        .doc();

    transaction.setTransactionId = docRef.id;
    transaction.setAccountId = account.accountId;
    transaction.setCategoryId = category.categoryId;
    await docRef.set(transaction.toJson());
  }

  Future<List<Models.Transaction>> getTransactions() async {
    final colRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions);

    final documents = (await colRef.get()).docs;
    return documents
        .map((doc) => Models.Transaction.fromJson(doc.data()))
        .toList();
  }

  Future<List<Models.Transaction>> getTransactionsByAccount(
      Models.Account acc) async {
    final snapshot = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions)
        .where('account_id', isEqualTo: acc.accountId)
        .get();

    final documents = snapshot.docs;
    return documents
        .map((doc) => Models.Transaction.fromJson(doc.data()))
        .toList();
  }

  //---categories---

  Future createCategory(Models.Category category) async {
    final DocumentReference docRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc();

    category.setCategoryId = docRef.id;
    await docRef.set(category.toJson());
  }

  Future<List<Models.Category>> getCategories() async {
    final colRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories);

    final documents = (await colRef.get()).docs;
    return documents
        .map((doc) => Models.Category.fromJson(doc.data()))
        .toList();
  }

  Future<Models.Category> getCategoryById(String id) async {
    final docRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc(id);

    final data = (await docRef.get()).data();
    return Models.Category.fromJson(data!);
  }
}
