import 'package:final_project/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;
import 'package:final_project/repositories/firebase_repository.dart';

class Controller {
  final repository = FirebaseRepository();

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

  Future<Account> getAccountById(String id) {
    return repository.getAccountById(id);
  }

  Future createTransaction(
      Transaction transaction, Account account, Category category) async {
    await repository.createTransaction(transaction, account, category);
  }

  Future updateTransaction(
      Transaction transaction, Account account, Category category) async {
    await repository.updateTransaction(transaction, account, category);
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
