import 'package:final_project/models/models.dart';
import 'package:final_project/views/transaction/form.dart';
import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';

class TransactionDetail extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetail(this.transaction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Detail"),
        actions: [
          IconButton(
            onPressed: () async {
              await controller.deleteTransaction(transaction);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TransactionForm(transaction: transaction),
                ),
              );
            },
            icon: const Icon(Icons.change_circle),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TweenAnimationBuilder(
            child: Center(
              child: _getAmountFromIncome(),
            ),
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            builder: (BuildContext context, double _val, Widget? child) {
              return Padding(
                padding: EdgeInsets.only(top: _val * 30),
                child: child,
              );
            },
          ),
          const SizedBox(height: 15),
          TweenAnimationBuilder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Text(
                  transaction.description,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                FutureBuilder<Account>(
                  future: Provider.of(context).getAccountById(
                    transaction.accountId,
                  ),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<Account> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      Account account = snapshot.data!;
                      return Text('Account: ${account.accountName}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 15),
                FutureBuilder<Category>(
                  future: Provider.of(context).getCategoryById(
                    transaction.categoryId,
                  ),
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<Category> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      Category category = snapshot.data!;
                      return Text('Category: ${category.categoryName}');
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 15),
                Text('Creation time: ${transaction.createdTime}'),
              ],
            ),
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            builder: (_, double _val, child) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  _val * 20,
                  0,
                  _val * 20,
                  0,
                ),
                child: child,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getAmountFromIncome() {
    return Text(
      '${transaction.income ? '+' : '-'}${transaction.amount}\$',
      style: TextStyle(
        fontSize: 30,
        color: transaction.income ? Colors.green : Colors.red,
      ),
    );
  }
}
