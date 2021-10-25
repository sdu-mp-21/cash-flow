import 'package:final_project/models/category.dart';

class User {
  late String _username;

  // ---keys--- //
  static const keyUsername = 'username';

  User(this._username);
  User.fromJSON(Map<String, dynamic> data) {
    this._username = data[keyUsername];
  }

  String get username => _username;

  Map<String, dynamic> toJSON() {
    return {
      'username': username,
    };
  }

}
