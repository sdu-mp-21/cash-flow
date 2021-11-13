import 'package:intl/intl.dart';

class Transaction {
  String _transactionId = '';
  late String _accountId;
  late String _categoryId;
  late int _amount;
  late bool _income;
  String _creationTime = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
  late String _description;

  static const keyTransactionId = 'transaction_id';
  static const keyAccountId = 'account_id';
  static const keyCategoryId =  'category_id';
  static const keyAmount = 'amount';
  static const keyIncome = 'income';
  static const keyCreationTime = 'creation_time';
  static const keyDescription = 'description';

  Transaction(this._amount, this._income, this._description);

  String get transaction_id => _transactionId;
  String get account_id => _accountId;
  String get categoryId => _categoryId;
  int get amount => _amount;
  bool get income => _income;
  String get createdTime => _creationTime;
  String get description => _description;

  set setTransactionId(String id) {
    _transactionId = id;
  }
  set setAccountId(String id) {
    _accountId = id;
  }
  set setCategoryId(String id) {
    _categoryId = id;
  }

  Map<String, dynamic> toJson() {
    return {
      keyTransactionId : _transactionId,
      keyAccountId : _accountId,
      keyCategoryId: _categoryId,
      keyAmount : _amount,
      keyIncome : _income,
      keyCreationTime : _creationTime,
      keyDescription : _description,
    };
  }

  Transaction.fromJson(Map<String, dynamic> data) {
    _transactionId = data[keyTransactionId];
    _accountId = data[keyAccountId];
    _categoryId = data[keyCategoryId];
    _amount = data[keyAmount];
    _income = data[keyIncome];
    _creationTime = data[keyCreationTime];
    _description = data[keyDescription];
  }
}