import 'package:final_project/models/models.dart';
import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';

import 'package:final_project/provider.dart';

class TransactionDetail extends StatelessWidget {
  late final Transaction transaction;

  TransactionDetail(this.transaction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Detail"),
        actions: [
          IconButton(
              onPressed: () async {
                final controller = Provider.of(context);
                await controller.deleteTransaction(transaction);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () async {
                final controller = Provider.of(context);
                await controller.deleteTransaction(transaction);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.change_circle)),
        ],
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
          SizedBox(height: 15),
          Text('Account ID: ${transaction.accountId}'),
          SizedBox(height: 15),
          FutureBuilder<Category>(
            future:
                Provider.of(context).getCategoryById(transaction.categoryId),
            builder: (BuildContext context, AsyncSnapshot<Category> snapshot) {
              if (snapshot.hasData) {
                Category category = snapshot.data!;
                return Text('Category: ${category.categoryName}');
              } else {
                return Text("Loading...");
              }
            },
          ),
          SizedBox(height: 15),
          Text('Creation time: ${transaction.createdTime}'),
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
