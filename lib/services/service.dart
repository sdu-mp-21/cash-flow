import 'package:final_project/models/models.dart';
import 'package:final_project/repositories/firebase.dart';

class Service {
  final repositories = FirebaseRepository();

  User get user => repositories.user;

  Future<bool> loginUser(User user) async {
    return await repositories.loginUser(user);
  }

  Future<bool> registerUser(User user) async {
    return await repositories.registerUser(user);
  }


// void clearUsers() {
  //   repositories.clearUsers();
  // }
  //
  // Future createAccount(Account account) async {
  //   await repositories.createAccount(account);
  // }
  //
  // Future<List<Account>> getAccounts() async {
  //   return await repositories.getAccounts();
  // }
  //
  // Future createTransaction(Account account, Transaction transaction) async {
  //   await repositories.createTransaction(account, transaction);
  // }
  //
  // Future<List<Transaction>> getTransactions() async {
  //   return await repositories.getTransactions();
  // }
  //
  // Future<List<Transaction>> getTransactionsByAccount(Account acc) async {
  //   return await repositories.getTransactionsByAccount(acc);
  // }
  //
  // Future createCategory(Category category) async {
  //   await repositories.createCategory(category);
  // }
  //
  // Future<Category> getCategory(int id) async {
  //   return await repositories.getCategory(id);
  // }
  //
  // Future<List<Category>> getCategories() async {
  //   return await repositories.getCategories();
  // }
}
