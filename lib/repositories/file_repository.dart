import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'package:final_project/repositories/repository.dart';
import 'package:final_project/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FileRepository extends Repository {

  User _user = User('guest');

  void registerUser(User user) {
    _user = user;
    // _writeJSON();
  }

  // Future<String> _getDirPath() async {
  //   // final _dir = await getApplicationDocumentsDirectory();
  //   return _dir.path;
  // }

  void _writeJSON() async {
    // final path = _getDirPath();
    final file = await File('assets/users.json');
    file.writeAsString('aaaaaa');
  }

  User get user => _user;
}