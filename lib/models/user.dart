class User {
  late int _user_id = 0;
  late String _username;
  late String _password;

  User(this._username, this._password);

  // ---keys--- //
  static const keyUserId = 'user_id';
  static const keyUsername = 'username';
  static const keyUserPassword = 'password';

  int get user_id => _user_id;

  String get username => _username;

  String get password => _password;

  set setID(int id) {
    _user_id = id;
  }

  User.fromJson(Map<String, dynamic> data) {
    this._user_id = data[keyUserId];
    this._username = data[keyUsername];
    this._password = data[keyUserPassword];
  }

  Map<String, dynamic> toJson() {
    return {
      keyUserId: _user_id,
      keyUsername: _username,
      keyUserPassword: _password,
    };
  }
}
