class Account {
  late int _account_id;
  late int _user_id;
  late String _account_name;
  late int _balance;

  Account(this._account_name, this._balance);

  static const keyAccountId = 'account_id';
  static const keyUserId = 'user_id';
  static const keyAccountName = 'account_name';
  static const keyBalance = 'balance';

  int get account_id => _account_id;

  int get user_id => _user_id;

  String get account_name => _account_name;

  int get balance => _balance;

  set setAccountId(int id) {
    _account_id = id;
  }

  set setUserId(int id) {
    _user_id = id;
  }

  set addToBalance(int amount) {
    _balance += amount;
  }

  @override
  bool operator ==(Object other) =>
      other is Account && other.account_name == account_name;

  @override
  int get hashCode => account_name.hashCode;

  Account.fromJson(Map<String, dynamic> data) {
    _account_id = data[keyAccountId];
    _user_id = data[keyUserId];
    _account_name = data[keyAccountName];
    _balance = data[keyBalance];
  }

  Map<String, dynamic> toJson() {
    return {
      keyAccountId: _account_id,
      keyUserId: _user_id,
      keyAccountName: _account_name,
      keyBalance: _balance,
    };
  }
}
