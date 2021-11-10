import 'package:intl/intl.dart';

class Transaction {
  late int _transactionId;
  late int _accountId;
  late int _amount;
  late bool _income;
  String _createdAt = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
  late String _description;
  late int _categoryId;

  static const keyTransactionId = 'transaction_id';
  static const keyAccountId = 'account_id';
  static const keyAmount = 'amount';
  static const keyIncome = 'income';
  static const keyCreatedAt = 'created_at';
  static const keyDescription = 'description';
  static const keyCategoryId = 'category_id';

  Transaction(this._amount, this._income, this._description, this._categoryId);

  int get transactionId => _transactionId;
  int get accountId => _accountId;
  int get amount => _amount;
  bool get income => _income;
  String get createdAt => _createdAt;
  String get description => _description;
  int get categoryId => _categoryId;

  set setTransactionId(int id) {
    _transactionId = id;
  }

  set setAccountId(int id) {
    _accountId = id;
  }

  Map<String, dynamic> toJson() {
    return {
      keyTransactionId: _transactionId,
      keyAccountId: _accountId,
      keyAmount: _amount,
      keyIncome: _income,
      keyCreatedAt: _createdAt,
      keyDescription: _description,
      keyCategoryId: _categoryId,
    };
  }

  Transaction.fromJson(Map<String, dynamic> data) {
    _transactionId = data[keyTransactionId];
    _accountId = data[keyAccountId];
    _amount = data[keyAmount];
    _income = data[keyIncome];
    _createdAt = data[keyCreatedAt];
    _description = data[keyDescription];
    _categoryId = data[keyCategoryId];
  }
}
