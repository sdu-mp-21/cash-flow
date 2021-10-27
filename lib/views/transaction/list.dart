import 'package:flutter/material.dart';

import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/views/transaction/creation.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  Map<String, int> categories = <String, int>{};

  final moneyController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(

        children: [
          Container(
            child: FutureBuilder(
              future: _buildTransactionList(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    // set the height to container, cause nester columns trigger overflow error
                    height: MediaQuery.of(context).size.height / 2,
                    child: ListView(children: snapshot.data!),
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
    return ListTile(
      title: transaction.amount,
      leading: transaction.created_at,
    );
  }
}
