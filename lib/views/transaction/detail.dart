import 'package:final_project/models/models.dart';
import 'package:flutter/material.dart';

class TransactionDetail extends StatelessWidget {
  late final Transaction transaction;

  TransactionDetail(this.transaction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Detail"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: _getAmountFromIncome(),
          ),
          SizedBox(height: 15),
          Text(
            "${transaction.description}",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Text('account_id: ${transaction.account_id}'),
          SizedBox(height: 15),
          Text('category_id: ${transaction.category_id}'),
          SizedBox(height: 15),
          Text('creation date: ${transaction.created_at}'),
        ],
      ),
    );
  }

  Widget _getAmountFromIncome() {
    if (transaction.income) {
      return Text('+${transaction.amount}\$',
          style: TextStyle(fontSize: 30, color: Colors.green));
    } else {
      return Text('-${transaction.amount}\$',
          style: TextStyle(fontSize: 30, color: Colors.red));
    }
  }
}
