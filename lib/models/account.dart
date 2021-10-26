class Account {
  late int _account_id = -1;
  late int _user_id;
  late String _account_name;
  late int _balance;

  Account(this._account_name, this._balance);

  static const keyAccountId = 'account_id';
  static const keyUserId = 'user_id';
  static const keyAccountName = 'account_name';
  static const keyBalance = 'balance';

  get account_id => _account_id;

  get user_id => _user_id;

  get account_name => _account_name;

  get balance => _balance;

  set setAccountId(int id) {
    _account_id = id;
  }

  set setUserId(int id) {
    _user_id = id;
  }

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
