import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/views/transaction/creation.dart';
import 'package:final_project/views/transaction/detail.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Expanded(
            child: TransactionsView(),
          ),
          Center(
            child: addTransactionButton(context),
          ),
        ],
      ),
    );
  }

  ElevatedButton addTransactionButton(BuildContext context) {
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

class TransactionsView extends StatelessWidget {
  final Account? account;
  const TransactionsView({Key? key, this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
    return StreamBuilder(
      stream: controller.getTransactionsStream(account: account),
      builder:
          (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
        var transactions = [];
        if (snapshot.hasData) {
          transactions = snapshot.data!;
        }
        final tiles =
            transactions.map((e) => TransactionTile(transaction: e)).toList();
        return _buildTransactionList(tiles);
        // return ListView(
        //   children:
        //       ListTile.divideTiles(context: context, tiles: tiles).toList(),
        // );
      },
    );
  }

  Widget _buildTransactionList(List<TransactionTile> tiles) {
    final res = <Widget>[];
    var time = "";
    for (var i = 0; i < tiles.length; i++) {
      if (tiles[i].transaction.createdTime.split(' ')[0] != time) {
        if (time != "") {
          res.add(const Divider());
        }
        time = tiles[i].transaction.createdTime.split(' ')[0];
        final row = Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(time, style: const TextStyle(fontWeight: FontWeight.w300)),
            ),
          ],
        );
        res.add(row);
      }
      res.add(tiles[i]);
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
