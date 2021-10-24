import 'package:final_project/models/user.dart';

class Controller {
  User user = User('guest');
  bool _authorized = false;

  Controller();

  set setUser(User user) {
    this.user = user;
    _authorized = true;
  }
  bool authorized() {
    return _authorized;
  }
}