import 'package:final_project/models/models.dart' as Models;

class Account {
  String _accountId = '';
  late String _accountName;
  late int _balance;

  Account(this._accountName, this._balance);

  static const keyAccountId = 'account_id';
  static const keyAccountName = 'account_name';
  static const keyBalance = 'balance';

  String get accountId => _accountId;

  String get accountName => _accountName;

  int get balance => _balance;

  set setAccountId(String id) {
    _accountId = id;
  }

  set addToBalance(int amount) {
    _balance += amount;
  }

  @override
  bool operator ==(Object other) =>
      other is Account && other._accountName == _accountName;

  @override
  int get hashCode => _accountName.hashCode;

  Account.fromJson(Map<String, dynamic> data) {
    _accountId = data[keyAccountId];
    _accountName = data[keyAccountName];
    _balance = data[keyBalance];
  }

  Map<String, dynamic> toJson() {
    return {
      keyAccountId: _accountId,
      keyAccountName: _accountName,
      keyBalance: _balance,
    };
  }
}
