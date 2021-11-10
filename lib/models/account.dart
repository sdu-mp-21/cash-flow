import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/models/transaction.dart' as Models;

class Account {
  late String _accountId = '';
  late String _accountName;
  late int _balance;
  List<Models.Transaction> _transactions = <Models.Transaction>[];

  // List<String> _categories = ['Health', 'Shop', 'Education'];
  // late int _userId;

  Account(this._accountName, this._balance);

  static const keyAccountId = 'account_id';
  static const keyAccountName = 'account_name';
  static const keyBalance = 'balance';
  static const keyTransactions = 'transactions';

  String get account_id => _accountId;

  String get account_name => _accountName;

  int get balance => _balance;

  set setAccountId(String id) {
    _accountId = id;
  }

  List<Models.Transaction> get getTransactions => _transactions;

  set addToBalance(int amount) {
    _balance += amount;
  }

  // @override
  // bool operator ==(Object other) =>
  //     other is Account && other.account_name == account_name;
  //
  // @override
  // int get hashCode => account_name.hashCode;

  Account.fromJson(String id, Map<String, dynamic> data) {
    _accountId = id;
    _accountName = data[keyAccountName];
    _balance = data[keyBalance];
    _transactions = data[keyTransactions].cast<Models.Transaction>(); // List<dynamic> -> List<Transaction>
  }

  Map<String, dynamic> toJson() {
    return {
      keyAccountId: _accountId,
      keyAccountName: _accountName,
      keyBalance: _balance,
      keyTransactions: _transactions,
    };
  }
}
