class Account {
  late int _accountId;
  late int _userId;
  late String _accountName;
  late int _balance;

  Account(this._accountName, this._balance);

  static const keyAccountId = 'account_id';
  static const keyUserId = 'user_id';
  static const keyAccountName = 'account_name';
  static const keyBalance = 'balance';

  int get accountId => _accountId;

  int get userId => _userId;

  String get accountName => _accountName;

  int get balance => _balance;

  set setAccountId(int id) {
    _accountId = id;
  }

  set setUserId(int id) {
    _userId = id;
  }

  set addToBalance(int amount) {
    _balance += amount;
  }

  @override
  bool operator ==(Object other) =>
      other is Account && other.accountName == accountName;

  @override
  int get hashCode => accountName.hashCode;

  Account.fromJson(Map<String, dynamic> data) {
    _accountId = data[keyAccountId];
    _userId = data[keyUserId];
    _accountName = data[keyAccountName];
    _balance = data[keyBalance];
  }

  Map<String, dynamic> toJson() {
    return {
      keyAccountId: _accountId,
      keyUserId: _userId,
      keyAccountName: _accountName,
      keyBalance: _balance,
    };
  }
}
