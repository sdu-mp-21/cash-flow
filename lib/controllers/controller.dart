import 'package:final_project/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;
import 'package:final_project/services/service.dart';

class Controller {
  final services = Service();

  User get user => services.user;

  loadUser(String email, String uid) {
    services.loadUser(email, uid);
  }

  Future<bool> loginUser(User user) async {
    return await services.loginUser(user);
  }

  Future<bool> registerUser(User user) async {
    return await services.registerUser(user);
  }

  Future createAccount(Account account) async {
    await services.createAccount(account);
  }

  Future<List<Account>> getAccounts() async {
    return await services.getAccounts();
  }

  fire.CollectionReference<Map<String, dynamic>> getAccountsDocuments() {
    return services.getAccountsDocuments();
  }

  Future createTransaction(
      Transaction transaction, Account account, Category category) async {
    await services.createTransaction(transaction, account, category);
  }

  fire.CollectionReference<Map<String, dynamic>> getTransactions() {
    return services.getTransactions();
  }

  Future<List<Transaction>> getTransactionsByAccount(Account account) async {
    return await services.getTransactionsByAccount(account);
  }

  Future deleteTransaction(Transaction transaction) async {
    await services.deleteTransaction(transaction);
  }

  Future createCategory(Category category) async {
    await services.createCategory(category);
  }

  Future<List<Category>> getCategories() async {
    return await services.getCategories();
  }

  fire.CollectionReference<Map<String, dynamic>> getCategoriesDocuments() {
    return services.getCategoriesDocuments();
  }

  Future<Category> getCategoryById(String id) async {
    return await services.getCategoryById(id);
  }

  fire.DocumentReference<Map<String, dynamic>> getCategoryDocumentById(
      String id) {
    return services.getCategoryDocumentById(id);
  }

  Future deleteCategory(Category category) async {
    await services.deleteCategory(category);
  }
}
