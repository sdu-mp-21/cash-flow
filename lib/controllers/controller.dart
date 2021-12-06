import 'package:cash_flow/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cash_flow/repositories/firebase_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire_auth;

class Controller {
  final repository = FirebaseRepository(
    firebaseAuthInstance: fire_auth.FirebaseAuth.instance,
    firestoreInstance: firestore.FirebaseFirestore.instance,
  );

  User get user => repository.user;

  loadUser(String email, String uid) {
    repository.loadUser(email, uid);
  }

  Future<String?> loginUser(User user) async {
    return await repository.loginUser(user);
  }

  Future<String?> registerUser(User user) async {
    return await repository.registerUser(user);
  }

  Future createAccount(Account account) async {
    await repository.createAccount(account);
  }

  Future<List<Account>> getAccounts() async {
    return await repository.getAccounts();
  }

  Stream<List<Account>> getAccountsStream() {
    return repository.getAccountsStream();
  }

  Future<Account> getAccountById(String id) async {
    return await repository.getAccountById(id);
  }

  Future<void> updateAccount(Account account) async {
    await repository.updateAccount(account);
  }

  Future<void> deleteAccount(Account account) async {
    await repository.deleteAccount(account);
  }

  Future createTransaction(
      Transaction transaction, Account account, Category category) async {
    await repository.createTransaction(transaction, account, category);
  }

  Future updateTransaction(Transaction old, Transaction updated) async {
    await repository.updateTransaction(old, updated);
  }

  Stream<List<Transaction>> getTransactionsStream({Account? account}) {
    return repository.getTransactionsStream(account: account);
  }

  Future deleteTransaction(Transaction transaction) async {
    await repository.deleteTransaction(transaction);
  }

  Future createCategory(Category category) async {
    await repository.createCategory(category);
  }

  Future<void> updateCategory(Category category) async {
    await repository.updateCategory(category);
  }

  Future<List<Category>> getCategories() async {
    return await repository.getCategories();
  }

  Stream<List<Category>> getCategoriesStream() {
    return repository.getCategoriesStream();
  }

  Future<Category> getCategoryById(String id) async {
    return await repository.getCategoryById(id);
  }

  Stream<Category> getCategoryStreamById(String id) {
    return repository.getCategoryStreamById(id);
  }

  Future deleteCategory(Category category) async {
    await repository.deleteCategory(category);
  }
}
