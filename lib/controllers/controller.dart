import 'package:final_project/models/user.dart';

class Controller {
  User? _user;

  User? get user => _user;
  set setUser(User user) {
    this._user = user;
  }
  bool authorized() {
    return _user != null;
  }
}