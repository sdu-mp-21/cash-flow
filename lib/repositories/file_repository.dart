import 'dart:io';
import 'dart:convert';

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

  Future<List<Account>> getAccounts() async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$accountsFilename');
    final accounts = await _readAccountsJSON(file);
    return accounts
        .where((account) => account.user_id == _user.user_id)
        .toList();
  }

  Future createAccount(Account account) async {
    File file = File(
        '${(await getApplicationDocumentsDirectory()).path}/$accountsFilename');

    final accounts = await _readAccountsJSON(file);
    account.setAccountId = _generateAccountId(accounts);
    account.setUserId = _user.user_id;
    accounts.add(account);
    final json = jsonEncode(accounts);
    await file.writeAsString(json);
  }

  Future<List<Account>> _readAccountsJSON(file) async {
    if (!file.existsSync()) return [];
    List<dynamic> accounts = jsonDecode(await file.readAsString());
    return accounts.map((item) => Account.fromJson(item)).toList();
  }

  int _generateAccountId(List<Account> accounts) {
    int maxId = accounts.fold(0, (a, b) => a > b.account_id ? a : b.account_id);
    return maxId + 1;
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

    user.setID = _generateUserID(users);
    users.add(user);
    await _writeUsersJSON(users);
    return true;
  }

  int _generateUserID(List<User> users) {
    int maxId = users.fold(0, (a, b) => a > b.user_id ? a : b.user_id);
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
