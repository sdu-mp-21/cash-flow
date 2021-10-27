class Transaction {
  late int _transaction_id;
  late int _account_id;
  late int _amount;
  late bool _income;
  String _created_at = DateTime.now().toString();
  late String _description;

  static const keyTransactionId = 'transaction_id';
  static const keyAccountId = 'account_id';
  static const keyAmount = 'amount';
  static const keyIncome = 'income';
  static const keyCreatedAt = 'created_at';
  static const keyDescription = 'description';

  Transaction(this._amount, this._income, this._description);

  int get transaction_id => _transaction_id;
  int get account_id => _account_id;
  int get amount => _amount;
  bool get income => _income;
  String get created_at => _created_at;
  String get description => _description;

  set setTransactionId(int id) {
    _transaction_id = id;
  }
  set setAccountId(int id) {
    _account_id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      keyTransactionId : _transaction_id,
      keyAccountId : _account_id,
      keyAmount : _amount,
      keyIncome : _income,
      keyCreatedAt : _created_at,
      keyDescription : _description,
    };
  }

  Transaction.fromJson(Map<String, dynamic> data) {
    _transaction_id = data[keyTransactionId];
    _account_id = data[keyAccountId];
    _amount = data[keyAmount];
    _income = data[keyIncome];
    _created_at = data[keyCreatedAt];
    _description = data[keyDescription];
  }
}