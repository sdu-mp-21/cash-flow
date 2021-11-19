import 'package:final_project/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;
import 'package:final_project/repositories/firebase_repository.dart';

class Service {
  final repositories = FirebaseRepository();

  User get user => repositories.user;

  loadUser(String email, String uid) {
    repositories.loadUser(email, uid);
  }

  Future<bool> loginUser(User user) async {
    return await repositories.loginUser(user);
  }

  Future<bool> registerUser(User user) async {
    return await repositories.registerUser(user);
  }

  Future createAccount(Account account) async {
    await repositories.createAccount(account);
  }

  Future<List<Account>> getAccounts() async {
    return await repositories.getAccounts();
  }

  fire.CollectionReference<Map<String, dynamic>> getAccountsDocuments() {
    return repositories.getAccountsDocuments();
  }

  Future createTransaction(
      Transaction transaction, Account account, Category category) async {
    await repositories.createTransaction(transaction, account, category);
  }

  fire.CollectionReference<Map<String, dynamic>> getTransactions() {
    return repositories.getTransactions();
  }

  Future<List<Transaction>> getTransactionsByAccount(Account acc) async {
    return await repositories.getTransactionsByAccount(acc);
  }

  Future deleteTransaction(Transaction transaction) async {
    await repositories.deleteTransaction(transaction);
  }

  Future createCategory(Category category) async {
    await repositories.createCategory(category);
  }

  Future<Category> getCategoryById(String id) async {
    return await repositories.getCategoryById(id);
  }

  fire.DocumentReference<Map<String, dynamic>> getCategoryDocumentById(
      String id) {
    return repositories.getCategoryDocumentById(id);
  }

  Future<List<Category>> getCategories() async {
    return await repositories.getCategories();
  }

  fire.CollectionReference<Map<String, dynamic>> getCategoriesDocuments() {
    return repositories.getCategoriesDocuments();
  }

  Future deleteCategory(Category category) async {
    await repositories.deleteCategory(category);
  }
}
