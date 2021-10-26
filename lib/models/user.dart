class User {
  late String _username;
  late int user_id = -1;

  // ---keys--- //
  static const keyUsername = 'username';
  static const keyUserId = 'user_id';

  User(this._username, this.user_id);
  User.fromJSON(Map<String, dynamic> data) {
    this._username = data[keyUsername];
    this.user_id = data[keyUserId];
  }

  String get username => _username;

  Map<String, dynamic> toJSON() {
    return {
      keyUserId : user_id,
      keyUsername : username,
    };
  }

}
