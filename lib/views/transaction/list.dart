import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/views/transaction/form.dart';
import 'package:final_project/views/transaction/detail.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: TransactionsList(),
        ),
        Center(
          child: addTransactionButton(context),
        ),
      ],
    );
  }

  Widget addTransactionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TransactionCreation(),
          ),
        );
      },
      child: const Text("Add transaction"),
    );
  }
}

class TransactionsList extends StatelessWidget {
  final Account? account;

  const TransactionsList({Key? key, this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
    return StreamBuilder(
      stream: controller.getTransactionsStream(account: account),
      builder:
          (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
        // if (snapshot.connectionState == ConnectionState.active) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        var transactions = [];
        if (snapshot.hasData) {
          transactions = snapshot.data!;
        }
        final tiles =
            transactions.map((e) => TransactionTile(transaction: e)).toList();
        return _buildList(tiles);
      },
    );
  }

  Widget _buildList(List<TransactionTile> tiles) {
    final res = <Widget>[];
    var time = "";

    for (var element in tiles) {
      final temp = element.transaction.createdTime.split(' ')[0];
      if (temp != time) {
        if (time != "") {
          res.add(const Divider());
        }
        time = temp;
        final timeText =
            Text(time, style: const TextStyle(fontWeight: FontWeight.w300));
        res.add(timeText);
      }
      res.add(element);
    }
    return ListView(
      children: res,
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({Key? key, required this.transaction})
      : super(key: key);
  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
    final isIncome = transaction.income ? '+' : '-';
    return ListTile(
      title: StreamBuilder(
        stream: controller.getCategoryStreamById(transaction.categoryId),
        builder: (BuildContext context, AsyncSnapshot<Category> snapshot) {
          if (snapshot.hasData) {
            final Category category = snapshot.data!;
            return Text(category.categoryName);
          }
          return const Text("Loading");
        },
      ),
      subtitle: Text(transaction.description),
      trailing: Text(
        isIncome + "${transaction.amount}\$",
        style: transaction.income
            ? const TextStyle(color: Colors.green, fontSize: 15)
            : const TextStyle(color: Colors.red, fontSize: 15),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetail(transaction),
          ),
        );
      },
    );
  }
}
