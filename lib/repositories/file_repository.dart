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
  static const usersFile = 'users.json';
  static const accountsFile = 'accounts.json';

  Future<List<Account>> getAccounts() async {
    File file = await File(
        '${(await getApplicationDocumentsDirectory()).path}/$accountsFile');
    await _createJSONFileIfNotExist(file);

    final accounts = await _readAccountsJSON(file);
    return accounts
        .where((account) => account.user_id == _user.user_id)
        .toList();
  }

  Future createAccount(Account account) async {
    File file = await File(
        '${(await getApplicationDocumentsDirectory()).path}/$accountsFile');
    await _createJSONFileIfNotExist(file);

    final accounts = await _readAccountsJSON(file);
    account.setAccountId = _generateAccountId(accounts);
    account.setUserId = _user.user_id;
    accounts.add(account);
    final json = _writeAccountsJSON(accounts);
    await file.writeAsString(json);
  }

  String _writeAccountsJSON(List<Account> accounts) {
    String json = '[';
    for (int i = 0; i < accounts.length; i++) {
      json += jsonEncode(accounts[i].toJSON());
      if (i < accounts.length - 1) {
        json += ',';
      }
    }
    json += ']';
    return json;
  }

  Future<List<Account>> _readAccountsJSON(File file) async {
    List<Account> accounts = <Account>[];
    List accountMaps = jsonDecode(await file.readAsString());
    accountMaps.forEach((account) {
      accounts.add(Account.fromJSON(account));
    });

    return accounts;
  }

  Future _createJSONFileIfNotExist(File file) async {
    if (!(await file.existsSync())) {
      await file.writeAsString('[]');
    }
  }

  int _generateAccountId(List<Account> accounts) {
    if (accounts.isEmpty) {
      return 1;
    }

    accounts.sort((a1, a2) => a1.account_id.compareTo(a2.account_id));
    return accounts.last.account_id + 1;
  }

  // ---authentication---

  Future<bool> loginUser(User user) async {
    final users = await _readUsersJSON();
    bool loggedIn = false;
    users.forEach((u) {
      if (u.username == user.username && u.password == user.password) {
        _user = u;
        loggedIn = true;
      }
    });
    return loggedIn;
  }

  Future<bool> registerUser(User user) async {
    final users = await _readUsersJSON();

    // check if we already have such username in database
    bool validUsername = true;
    users.forEach((u) {
      if (u.username == user.username) {
        validUsername = false;
      }
    });
    if (!validUsername) {
      return false;
    }

    user.setID = _generateUserID(users);
    users.add(user);
    await _writeUsersJSON(users);
    return true;
  }

  int _generateUserID(List<User> list) {
    if (list.length == 0) {
      return 1;
    }

    list.sort((u1, u2) => u1.user_id.compareTo(u2.user_id));
    return list.last.user_id + 1;
  }

  Future<List<User>> _readUsersJSON() async {
    final file = await File(
        '${(await getApplicationDocumentsDirectory()).path}/$usersFile');

    await _createJSONFileIfNotExist(file);

    List<User> users = <User>[];
    List userMaps = jsonDecode(await file.readAsString());
    userMaps.forEach((user) {
      users.add(User.fromJSON(user));
    });

    return users;
  }

  Future _writeUsersJSON(List<User> list) async {
    final file = await File(
        '${(await getApplicationDocumentsDirectory()).path}/users.json');

    var json = '[';
    for (int i = 0; i < list.length; i++) {
      json += jsonEncode(list[i].toJSON()) + (i < list.length - 1 ? ',' : '');
    }
    json += ']';

    file.writeAsString(json);
  }

  // only for testing purposes
  clearUsers() async {
    final file = await File(
        '${(await getApplicationDocumentsDirectory()).path}/$usersFile');
    await file.writeAsString('[]');
  }
}
