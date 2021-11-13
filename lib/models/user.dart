class User {
  late String _userId = '';
  late String _email;
  late String _password;

  User(this._email, this._password);

  // ---keys--- //
  static const keyUserId = 'user_id';
  static const keyEmail = 'email';
  static const keyUserPassword = 'password';

  String get userId => _userId;

  String get email => _email;

  String get password => _password;

  set setID(String id) {
    _userId = id;
  }

  User.fromJson(Map<String, dynamic> data) {
    this._userId = data[keyUserId];
    this._email = data[keyEmail];
    this._password = data[keyUserPassword];
  }

  Map<String, dynamic> toJson() {
    return {
      keyUserId: _userId,
      keyEmail: _email,
      keyUserPassword: _password,
    };
  }
}
