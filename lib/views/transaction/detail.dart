import 'package:final_project/models/models.dart';
import 'package:flutter/material.dart';

class TransactionDetail extends StatelessWidget {
  late final Transaction transaction;

  TransactionDetail(this.transaction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Detail"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: _getAmountFromIncome(),
          ),
          const SizedBox(height: 15),
          Text(
            "${transaction.description}",
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Text('account_id: ${transaction.accountId}'),
          const SizedBox(height: 15),
          Text('category_id: ${transaction.categoryId}'),
          const SizedBox(height: 15),
          Text('creation date: ${transaction.createdAt}'),
        ],
      ),
    );
  }

  Widget _getAmountFromIncome() {
    if (transaction.income) {
      return Text('+${transaction.amount}\$',
          style: const TextStyle(fontSize: 30, color: Colors.green));
    } else {
      return Text('-${transaction.amount}\$',
          style: const TextStyle(fontSize: 30, color: Colors.red));
    }
  }
}
