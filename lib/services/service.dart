import 'package:final_project/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;
import 'package:final_project/repositories/firebase_repository.dart';

class Service {
  final repositories = FirebaseRepository();

  User get user => repositories.user;

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

  Future<List<Transaction>> getTransactions() async {
    return await repositories.getTransactions();
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

  Future<List<Category>> getCategories() async {
    return await repositories.getCategories();
  }

  Future deleteCategory(Category category) async {
    await repositories.deleteCategory(category);
  }
}
