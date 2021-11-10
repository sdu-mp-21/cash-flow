class User {
  late int _userId = 0;
  late String _username;
  late String _password;

  User(this._username, this._password);

  // ---keys--- //
  static const keyUserId = 'user_id';
  static const keyUsername = 'username';
  static const keyUserPassword = 'password';

  int get userId => _userId;

  String get username => _username;

  String get password => _password;

  set setID(int id) {
    _userId = id;
  }

  User.fromJson(Map<String, dynamic> data) {
    _userId = data[keyUserId];
    _username = data[keyUsername];
    _password = data[keyUserPassword];
  }

  Map<String, dynamic> toJson() {
    return {
      keyUserId: _userId,
      keyUsername: _username,
      keyUserPassword: _password,
    };
  }
}
