import 'dart:io';
import 'dart:convert';

import 'package:final_project/models/transaction.dart';
import 'package:path_provider/path_provider.dart';
import 'package:final_project/repositories/repository.dart';
import 'package:final_project/models/models.dart';

class FileRepository extends Repository {
  User _user = User(defaultUsername, defaultPassword);

  User get user => _user;

  // ---constants---
  static const defaultUsername = 'guest';
  static const defaultPassword = 'password';
  static const usersFilename = 'users.json';
  static const accountsFilename = 'accounts.json';
  static const transactionsFilename = 'transactions.json';
  static const categoriesFileName = 'categories.json';

  // ---transactions---

  @override
  Future createTransaction(Account account, Transaction transaction) async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$transactionsFilename');
    final transactions = await _readTransactionsJSON(file);

    transaction.setAccountId = account.accountId;
    transaction.setTransactionId = _generateTransactionId(transactions);
    transactions.add(transaction);
    final json = jsonEncode(transactions);
    await file.writeAsString(json);
    await updateAccountBalanceByAmount(
        account.accountId, transaction.amount * (transaction.income ? 1 : -1));
  }

  Future deleteTransaction(Transaction transaction) async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$transactionsFilename');
    final transactions = await _readTransactionsJSON(file);
    transactions.removeWhere(
        (element) => transaction.transactionId == element.transactionId);
    final json = jsonEncode(transactions);
    await file.writeAsString(json);
    await updateAccountBalanceByAmount(transaction.accountId,
        transaction.amount * (transaction.income ? -1 : 1));
  }

  Future updateAccountBalanceByAmount(int accountId, int amount) async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$accountsFilename');

    final list = await _readAccountsJSON(file);
    list.singleWhere((element) => element.accountId == accountId).addToBalance =
        amount;
    await file.writeAsString(jsonEncode(list));
  }

  int _generateTransactionId(List<Transaction> transactions) {
    int maxId = transactions.fold(
        0, (a, b) => a > b.transactionId ? a : b.transactionId);
    return maxId + 1;
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$transactionsFilename');

    final transactions = await _readTransactionsJSON(file);
    final usersTransactions = <Transaction>[];
    final accounts = await getAccounts();
    for (var acc in accounts) {
      usersTransactions.addAll(
          transactions.where((t) => t.accountId == acc.accountId).toList());
    }
    return usersTransactions;
  }

  Future<List<Transaction>> getTransactionsByAccount(Account acc) async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$transactionsFilename');
    final transactions = await _readTransactionsJSON(file);
    return transactions.where((t) => t.accountId == acc.accountId).toList();
  }

  Future<List<Transaction>> _readTransactionsJSON(File file) async {
    if (!file.existsSync()) return [];
    try {
      List transactions = jsonDecode(await file.readAsString());
      return transactions.map((t) => Transaction.fromJson(t)).toList();
    } catch (e) {
      print(e);
      file.writeAsString('[]');
      return [];
    }
  }

  // ---accounts---

  @override
  Future createAccount(Account account) async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$accountsFilename');

    final accounts = await _readAccountsJSON(file);
    account.setAccountId = _generateAccountId(accounts);
    account.setUserId = _user.userId;
    accounts.add(account);
    final json = jsonEncode(accounts);
    await file.writeAsString(json);
  }

  int _generateAccountId(List<Account> accounts) {
    int maxId = accounts.fold(0, (a, b) => a > b.accountId ? a : b.accountId);
    return maxId + 1;
  }

  @override
  Future<List<Account>> getAccounts() async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$accountsFilename');
    final accounts = await _readAccountsJSON(file);
    return accounts.where((account) => account.userId == _user.userId).toList();
  }

  Future<List<Account>> _readAccountsJSON(file) async {
    if (!file.existsSync()) return [];
    List<dynamic> accounts = jsonDecode(await file.readAsString());
    return accounts.map((item) => Account.fromJson(item)).toList();
  }

  // ---categories---
  Future createCategory(Category category) async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$categoriesFileName');
    final categories = await _readCategoriesJSON(file);

    category.setCategoryId = _generateCategoryId(categories);
    category.setUserId = _user.userId;
    categories.add(category);
    final json = jsonEncode(categories);
    await file.writeAsString(json);
  }

  int _generateCategoryId(List<Category> categories) {
    int maxId =
        categories.fold(0, (a, b) => a > b.categoryId ? a : b.categoryId);
    return maxId + 1;
  }

  Future<Category> getCategory(int id) async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$categoriesFileName');
    final categories = await _readCategoriesJSON(file);
    return categories.singleWhere((c) => c.categoryId == id);
  }

  Future<List<Category>> getCategories() async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$categoriesFileName');
    return await _readCategoriesJSON(file);
  }

  Future<List<Category>> _readCategoriesJSON(file) async {
    if (!file.existsSync()) return [];
    List<dynamic> categories = jsonDecode(await file.readAsString());
    return categories.map((item) => Category.fromJson(item)).toList();
  }

  // ---authentication---

  @override
  Future<bool> loginUser(User user) async {
    final users = await _readUsersJSON();
    try {
      _user = users.singleWhere(
          (u) => u.username == user.username && u.password == user.password);
    } on StateError {
      return false;
    }
    return true;
  }

  @override
  Future<bool> registerUser(User user) async {
    final users = await _readUsersJSON();

    // check if we already have such username in database
    bool validUsername = !users.any((u) => u.username == user.username);
    if (!validUsername) {
      return false;
    }

    user.setID = _generateUserId(users);
    users.add(user);
    await _writeUsersJSON(users);
    return true;
  }

  int _generateUserId(List<User> users) {
    int maxId = users.fold(0, (a, b) => a > b.userId ? a : b.userId);
    return maxId + 1;
  }

  Future<List<User>> _readUsersJSON() async {
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$usersFilename');
    if (!file.existsSync()) return [];
    List<dynamic> users = jsonDecode(await file.readAsString());
    return users.map((item) => User.fromJson(item)).toList();
  }

  Future _writeUsersJSON(List<User> list) async {
    final file =
        File('${(await getApplicationDocumentsDirectory()).path}/users.json');
    var json = jsonEncode(list);
    file.writeAsString(json);
  }

  // only for testing purposes
  clearUsers() async {
    final file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$usersFilename');
    await file.writeAsString('[]');
  }
}
