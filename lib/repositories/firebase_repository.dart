import 'dart:async';
import 'package:final_project/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:final_project/repositories/repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

class FirebaseRepository implements Repository {
  final fire_auth.FirebaseAuth _firebaseAuth = fire_auth.FirebaseAuth.instance;
  final firestore.CollectionReference collectionUsersReference =
      firestore.FirebaseFirestore.instance.collection(collectionUsers);

  static const collectionUsers = 'users';
  static const collectionAccounts = 'accounts';
  static const collectionTransactions = 'transactions';
  static const collectionCategories = 'categories';

  // for developing purposes, todo: delete initialization and make it 'late'
  User _user = User('dias@mail.com', 'qwerty');

  User get user => _user;

  loadUser(String email, String uid) {
    _user = User(email, '******');
    _user.setID = uid;
  }

  @override
  Future<String?> loginUser(User u) async {
    try {
      final fire_auth.UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: u.email,
        password: u.password,
      );
      u.setID = credential.user!.uid;
      _user = u;
    } catch (error) {
      return error.toString();
    }
    return null;
  }

  @override
  Future<String?> registerUser(User u) async {
    try {
      final fire_auth.UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: u.email,
        password: u.password,
      );
      u.setID = credential.user!.uid;
      _user = u;

      await createAccount(Account('Account1', 0));
      await createCategory(Category('Health'));
    } catch (error) {
      return error.toString();
    }
    return null;
  }

  //---accounts---

  @override
  Future createAccount(Account account) async {
    final docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts)
        .doc();

    account.setAccountId = docRef.id;
    await docRef.set(account.toJson());
  }

  @override
  Future<List<Account>> getAccounts() async {
    final colRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts);

    final documents = (await colRef.get()).docs;
    return documents.map((doc) => Account.fromJson(doc.data())).toList();
  }

  Stream<List<Account>> getAccountsStream() async* {
    final colRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts);
    final stream = colRef.snapshots();
    await for (final snapshot in stream) {
      final rawAccounts = snapshot.docs;
      final accounts =
          rawAccounts.map((e) => Account.fromJson(e.data())).toList();
      yield accounts;
    }
  }

  @override
  Future<Account> getAccountById(String id) async {
    final docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts)
        .doc(id);
    final data = (await docRef.get()).data();
    return Account.fromJson(data!);
  }

  Future updateAccountBalanceByAmount(
      String accountId, int amount, bool income) async {
    final docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts)
        .doc(accountId);

    final snapshot = await docRef.get();
    if (snapshot.data() == null) {
      return;
    }
    int balance = snapshot.data()!["balance"];
    balance += (income) ? amount : -amount;
    await docRef.update({"balance": balance});
  }

  @override
  Future<void> updateAccount(Account account) async {
    final docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts)
        .doc(account.accountId);

    docRef.set(account.toJson());
  }

  @override
  Future<void> deleteAccount(Account account) async {
    await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionAccounts)
        .doc(account.accountId)
        .delete();
  }

  Future<void> deleteTransactionsByAccount(Account account) async {
    final colRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions);

    final snapshot =
        await colRef.where('account_id', isEqualTo: account.accountId).get();

    for (var element in snapshot.docs) {
      await colRef.doc(element.id).delete();
    }
  }

  //---transactions---

  @override
  Future<void> createTransaction(
      Transaction transaction, Account account, Category category) async {
    final firestore.DocumentReference docRef = collectionUsersReference
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

  @override
  Future<void> updateTransaction(Transaction old, Transaction updated) async {
    final firestore.DocumentReference docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions)
        .doc(old.transactionId);

    await updateAccountBalanceByAmount(old.accountId, old.amount, !old.income);
    await updateAccountBalanceByAmount(
        updated.accountId, updated.amount, updated.income);
    await docRef.set(updated.toJson());
  }

  @override
  Stream<List<Transaction>> getTransactionsStream({Account? account}) async* {
    final colRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions)
        .orderBy("creation_time", descending: true);
    final stream = colRef.snapshots();
    await for (final snapshot in stream) {
      final rawTransactions = snapshot.docs;
      var transactions =
          rawTransactions.map((e) => Transaction.fromJson(e.data())).toList();

      if (account != null) {
        transactions = transactions
            .where((e) => e.accountId == account.accountId)
            .toList();
      }

      yield transactions;
    }
  }

  @override
  Future<void> deleteTransaction(Transaction transaction) async {
    await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionTransactions)
        .doc(transaction.transactionId)
        .delete();
    await updateAccountBalanceByAmount(
        transaction.accountId, transaction.amount, !transaction.income);
  }

  //---categories---

  @override
  Future createCategory(Category category) async {
    final firestore.DocumentReference docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc();
    category.setCategoryId = docRef.id;
    await docRef.set(category.toJson());
  }

  @override
  Future<void> updateCategory(Category category) async {
    final docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc(category.categoryId);

    docRef.set(category.toJson());
  }

  @override
  Future<List<Category>> getCategories() async {
    final colRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories);

    final documents = (await colRef.get()).docs;
    return documents.map((doc) => Category.fromJson(doc.data())).toList();
  }

  Stream<List<Category>> getCategoriesStream() async* {
    final colRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories);

    final stream = colRef.snapshots();
    await for (final snapshot in stream) {
      final rawCategories = snapshot.docs;
      final categories =
          rawCategories.map((e) => Category.fromJson(e.data())).toList();
      yield categories;
    }
  }

  @override
  Future<Category> getCategoryById(String id) async {
    if (id == '') return Category.empty;

    final docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc(id);

    final data = (await docRef.get()).data();
    if (data == null) {
      return Category.empty;
    }
    return Category.fromJson(data);
  }

  Stream<Category> getCategoryStreamById(String id) async* {
    if (id == '') {
      yield Category.empty;
      return;
    }

    final docRef = collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc(id);
    final docsStream = docRef.snapshots();
    await for (final doc in docsStream) {
      if (doc.data() != null) {
        yield Category.fromJson(doc.data()!);
      } else {
        yield Category.empty;
      }
    }
  }

  @override
  Future<void> deleteCategory(Category category) async {
    await collectionUsersReference
        .doc(_user.userId)
        .collection(collectionCategories)
        .doc(category.categoryId)
        .delete();
  }
}
