import 'package:final_project/models/models.dart' as Models;

class Account {
  late String _accountId = '';
  late String _accountName;
  late int _balance;

  Account(this._accountName, this._balance);

  static const keyAccountId = 'account_id';
  static const keyAccountName = 'account_name';
  static const keyBalance = 'balance';

  String get account_id => _accountId;
  String get account_name => _accountName;

  int get balance => _balance;

  set setAccountId(String id) {
    _accountId = id;
  }

  set addToBalance(int amount) {
    _balance += amount;
  }

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
