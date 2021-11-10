import 'package:flutter/material.dart';

import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/views/transaction/creation.dart';
import 'package:final_project/views/transaction/detail.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final moneyController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _buildTransactionList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    child: ListView(
                      children: ListTile.divideTiles(
                              context: context, tiles: snapshot.data!)
                          .toList(),
                    ),
                  );
                } else {
                  return Text('loading...');
                }
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionCreation(),
                  ),
                ).then((value) => setState(() {}));
              },
              child: const Text("Add transaction"),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Widget>> _buildTransactionList() async {
    final transactions = await Provider.of(context).getTransactions();
    final tiles = <Widget>[];
    transactions.forEach((t) {
      tiles.add(_buildTransactionTile(t));
    });
    return tiles;
  }

  Widget _buildTransactionTile(Transaction transaction) {
    String isIncome = '';
    transaction.income ? isIncome = '+' : isIncome = '-';
    final controller = Provider.of(context);

    return ListTile(
        title: Text(transaction.category),
        subtitle: Text(transaction.description),
        trailing: Text(
          "$isIncome" + "${transaction.amount}\$",
          style: transaction.income
              ? TextStyle(color: Colors.green, fontSize: 15)
              : TextStyle(color: Colors.red, fontSize: 15),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetail(transaction),
            ),
          );
        });
  }
}
