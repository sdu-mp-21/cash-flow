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

  Future<bool> loginUser(User user) async {
    final list = await _readUsersJSON();
    bool loggedIn = false;
    list.forEach((u) {
      if (u.username == user.username && u.password == user.password) {
        _user = u;
        loggedIn = true;
      }
    });
    return loggedIn;
  }

  Future<bool> registerUser(User user) async {
    final list = await _readUsersJSON();

    // check if we already have such username in database
    bool validUsername = true;
    list.forEach((u) {
      if (u.username == user.username) {
        validUsername = false;
      }
    });
    if (!validUsername) {
      return false;
    }

    user.setID = _generateUserID(list);
    list.add(user);
    await _writeUsersJSON(list);
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
  void clearUsers() async {
    final file = await File(
        '${(await getApplicationDocumentsDirectory()).path}/$usersFile');
    await file.writeAsString('[]');
  }
}
