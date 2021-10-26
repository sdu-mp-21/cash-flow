import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:final_project/repositories/repository.dart';
import 'package:final_project/models/models.dart';

class FileRepository extends Repository {

  User _user = User('guest', 0);
  User get user => _user;

  static const usersFile = 'users.json';

  Future registerUser(String username) async {
    final list = await _readUsersJSON();
    _user = User(username, _generateUserID(list));
    list.add(_user);
    _writeUsersJSON(list);
    // list.forEach((u) {
    //   print('${u.user_id} : ${u.username}');
    // });
  }

  int _generateUserID(List<User> list) {
    if (list.length == 0) {
      return 1;
    }

    list.sort((u1, u2) => u1.user_id.compareTo(u2.user_id));
    return list.last.user_id + 1;
  }

  Future<List<User>> _readUsersJSON() async {
    final file = await File('${(await getApplicationDocumentsDirectory()).path}/$usersFile');

    List<User> users = <User>[];
    List userMaps = jsonDecode(await file.readAsString());
    userMaps.forEach((user) {
      users.add(User.fromJSON(user));
    });

    return users;
  }

  void _writeUsersJSON(List<User> list) async {
    final file = await File('${(await getApplicationDocumentsDirectory()).path}/users.json');

    var json = '[';
    for(int i=0;i<list.length;i++) {
      json += jsonEncode(list[i].toJSON()) + (i<list.length-1 ? ',' : '');
    }
    json += ']';

    file.writeAsString(json);
  }

  // only for testing purposes
  void clearUsers() async {
    final file = await File('${(await getApplicationDocumentsDirectory()).path}/$usersFile');
    await file.writeAsString('[]');
  }
}