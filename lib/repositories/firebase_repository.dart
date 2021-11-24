import 'dart:async';
import 'dart:convert';
import 'package:final_project/models/models.dart' as models;
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

  static const categoryNotFound = "Uncategorized";

  // for developing purposes, todo: delete initialization and make it 'late'
  models.User _user = models.User('dias@mail.com', 'qwerty');

  models.User get user => _user;

  loadUser(String email, String uid) {
    _user = models.User(email, '******');
    _user.setID = uid;
  }

  Future<bool> loginUser(models.User u) async {
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

  Future<bool> registerUser(models.User u) async {
    try {
      final UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: u.email,
        password: u.password,
      );
      u.setID = credential.user!.uid;
      _user = u;

      await createAccount(models.Account('Account1', 0));
      await createCategory(models.Category('Health'));
    } catch (error) {
      print(error);
      return false;
    }
    return true;
  }

  //---accounts---

  Future createAccount(models.Account account) async {
    final docRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts)
        .doc();

    account.setAccountId = docRef.id;
    await docRef.set(account.toJson());
  }

  Future<List<models.Account>> getAccounts() async {
    final colRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts);

    final documents = (await colRef.get()).docs;
    return documents.map((doc) => models.Account.fromJson(doc.data())).toList();
  }

  CollectionReference<Map<String, dynamic>> getAccountsDocuments() {
    return collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts);
  }

  Future updateAccountBalanceByAmount(
      String accountId, int amount, bool income) async {
    final docRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts)
        .doc(accountId);

    final snapshot = await docRef.get();
    int balance = snapshot.data()!["balance"];
    balance += (income) ? amount : -amount;
    await docRef.update({"balance": balance});
  }

  //---transactions---

  Future createTransaction(models.Transaction transaction,
      models.Account account, models.Category category) async {
    final DocumentReference docRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions)
        .doc();

    transaction.setTransactionId = docRef.id;
    transaction.setAccountId = account.accountId;
    transaction.setCategoryId = category.categoryId;
    await updateAccountBalanceByAmount(
        account.accountId, transaction.amount, transaction.income);
    await docRef.set(transaction.toJson());
  }

  CollectionReference<Map<String, dynamic>> getTransactions() {
    final colRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions);

    return colRef;
  }

  Stream<List<models.Transaction>> getTransactionsStream({models.Account? account}) async* {
    final colRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions);
    final stream = colRef.snapshots();
    await for (final snapshot in stream) {
      final rawTransactions = snapshot.docs;
      var transactions = rawTransactions
          .map((e) => models.Transaction.fromJson(e.data()))
          .toList();

      if(account != null) {
        transactions = transactions.where((e) => e.accountId == account!.accountId).toList();
      }

      yield transactions;
    }
  }

  Future deleteTransaction(models.Transaction transaction) async {
    await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions)
        .doc(transaction.transactionId)
        .delete();
    await updateAccountBalanceByAmount(
        transaction.accountId, transaction.amount, !transaction.income);
  }

  //---categories---

  Future createCategory(models.Category category) async {
    final DocumentReference docRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc();
    category.setCategoryId = docRef.id;
    await docRef.set(category.toJson());
  }

  Future<List<models.Category>> getCategories() async {
    final colRef = await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories);

    final documents = (await colRef.get()).docs;
    return documents
        .map((doc) => models.Category.fromJson(doc.data()))
        .toList();
  }

  Stream<List<models.Category>> getCategoriesStream() async* {
    final colRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories);

    final stream = colRef.snapshots();
    await for (final snapshot in stream) {
      final rawCategories = snapshot.docs;
      final categories =
          rawCategories.map((e) => models.Category.fromJson(e.data())).toList();
      yield categories;
    }
  }

  Future<models.Category> getCategoryById(String id) async {
    final docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc(id);

    final data = (await docRef.get()).data();
    if (data == null) {
      return models.Category(categoryNotFound);
    }
    return models.Category.fromJson(data);
  }

  Stream<models.Category> getCategoryStreamById(String id) async* {
    final docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc(id);
    final docsStream = docRef.snapshots();
    await for (final doc in docsStream) {
      if (doc.data() != null) {
        yield models.Category.fromJson(doc.data()!);
      } else {
        yield models.Category(categoryNotFound);
      }
    }
  }

  Future deleteCategory(models.Category category) async {
    await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc(category.categoryId)
        .delete();
  }
}
