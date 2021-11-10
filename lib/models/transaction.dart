import 'package:intl/intl.dart';

class Transaction {
  String _transactionId = '';
  late String _accountId;
  late int _amount;
  late bool _income;
  String _creationTime = DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now());
  late String _description;
  late String _category;

  static const keyTransactionId = 'transaction_id';
  static const keyAccountId = 'account_id';
  static const keyAmount = 'amount';
  static const keyIncome = 'income';
  static const keyCreationTime = 'creation_time';
  static const keyDescription = 'description';
  static const keyCategory =  'category';

  Transaction(this._amount, this._income, this._description, this._category);

  String get transaction_id => _transactionId;
  String get account_id => _accountId;
  int get amount => _amount;
  bool get income => _income;
  String get createdTime => _creationTime;
  String get description => _description;
  String get category => _category;

  set setTransactionId(String id) {
    _transactionId = id;
  }
  set setAccountId(String id) {
    _accountId = id;
  }

  Map<String, dynamic> toJson() {
    return {
      keyTransactionId : _transactionId,
      keyAccountId : _accountId,
      keyAmount : _amount,
      keyIncome : _income,
      keyCreationTime : _creationTime,
      keyDescription : _description,
      keyCategory: _category,
    };
  }

  Transaction.fromJson(Map<String, dynamic> data) {
    _transactionId = data[keyTransactionId];
    _accountId = data[keyAccountId];
    _amount = data[keyAmount];
    _income = data[keyIncome];
    _creationTime = data[keyCreationTime];
    _description = data[keyDescription];
    _category = data[keyCategory];
  }
}