import 'package:final_project/models/models.dart';
import 'package:final_project/views/transaction/updation.dart';
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
              icon: const Icon(Icons.delete)),
          IconButton(
              onPressed: () async {
                final account =
                    controller.getAccountById(transaction.accountId);
                final category =
                    await controller.getCategoryById(transaction.categoryId);
                final loadedAccount = await account;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TransactionUpdate(transaction, loadedAccount, category),
                  ),
                );
              },
              icon: const Icon(Icons.change_circle)),
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
              duration: const Duration(seconds: 1),
              builder: (BuildContext context, double _val, Widget? child) {
                return Opacity(
                  opacity: _val,
                  child: Padding(
                    padding: EdgeInsets.only(top: _val * 100),
                    child: child!,
                  ),
                );
              }),
          const SizedBox(height: 15),
          // Text(
          //   "${transaction.description}",
          //   style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          // ),
          TweenAnimationBuilder(
              child: Text(
                transaction.description,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (BuildContext context, double _val, Widget? child) {
                return Opacity(
                  opacity: _val,
                  child: Padding(
                    padding: EdgeInsets.only(left: _val * 50),
                    child: child!,
                  ),
                );
              }),
          const SizedBox(height: 15),
          // Text('Account ID: ${transaction.accountId}'),
          TweenAnimationBuilder(
            child: Text("Account ID: ${transaction.accountId}"),
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            builder: (BuildContext context, double _val, Widget? child) {
              return Opacity(
                opacity: _val,
                child: Padding(
                  padding: EdgeInsets.only(left: _val * 50),
                  child: child!,
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          // FutureBuilder<Category>(
          //   future:
          //       Provider.of(context).getCategoryById(transaction.categoryId),
          //   builder: (BuildContext context, AsyncSnapshot<Category> snapshot) {
          //     if (snapshot.hasData) {
          //       Category category = snapshot.data!;
          //       return Text('Category: ${category.categoryName}');
          //     } else {
          //       return Text("Loading...");
          //     }
          //   },
          // ),
          TweenAnimationBuilder(
              child: FutureBuilder<Category>(
                future: Provider.of(context)
                    .getCategoryById(transaction.categoryId),
                builder:
                    (BuildContext context, AsyncSnapshot<Category> snapshot) {
                  if (snapshot.hasData) {
                    Category category = snapshot.data!;
                    return Text('Category: ${category.categoryName}');
                  } else {
                    return const Text("Loading...");
                  }
                },
              ),
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 1),
              builder: (BuildContext context, double _val, Widget? child) {
                return Opacity(
                  opacity: _val,
                  child: Padding(
                    padding: EdgeInsets.only(left: _val * 50),
                    child: child!,
                  ),
                );
              }),
          const SizedBox(height: 15),
          // Text('Creation time: ${transaction.createdTime}'),
          TweenAnimationBuilder(
            child: Text('Creation time: ${transaction.createdTime}'),
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 1),
            builder: (BuildContext context, double _val, Widget? child) {
              return Opacity(
                opacity: _val,
                child: Padding(
                  padding: EdgeInsets.only(left: _val * 50),
                  child: child!,
                ),
              );
            },
          ),
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
