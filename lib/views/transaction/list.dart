import 'package:flutter/material.dart';

import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/views/transaction/creation.dart';
import 'package:final_project/views/transaction/detail.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;

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
    final controller = Provider.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            child: StreamBuilder(
              stream: controller.getTransactions().snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<fire.QuerySnapshot<Map<String, dynamic>>>
                      snapshot) {
                final documents = snapshot.data?.docs ?? [];
                if (documents.isEmpty) {
                  return const Text("");
                }
                final transactions = documents
                    .map((doc) => Transaction.fromJson(doc.data()))
                    .toList();

                // final chartData = getChartValue(transactions);
                return StreamBuilder(
                  stream: controller.getCategoriesDocuments().snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<fire.QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    final categoryDocuments = snapshot.data?.docs ?? [];
                    if (categoryDocuments.isEmpty) {
                      return const Text("Loading");
                    }
                    final categories = categoryDocuments
                        .map((e) => Category.fromJson(e.data()))
                        .toList();
                    Map<String, String> transactionToCategory = {};
                    for (var transaction in transactions) {
                      for (var category in categories) {
                        if (transaction.categoryId == category.categoryId) {
                          transactionToCategory[transaction.transactionId] =
                              category.categoryName;
                          break;
                        }
                      }
                    }
                    return SfCircularChart(
                      title: ChartTitle(text: "transaction amount chart"),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CircularSeries>[
                        DoughnutSeries<ChartValue, String>(
                            dataSource: getChartValue(
                                transactions, transactionToCategory),
                            xValueMapper: (ChartValue data, _) => data.category,
                            yValueMapper: (ChartValue data, _) => data.amount,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            enableTooltip: true)
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: controller.getTransactions().snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<fire.QuerySnapshot<Map<String, dynamic>>>
                      snapshot) {
                final documents = snapshot.data?.docs ?? [];
                final transactions = documents
                    .map((doc) => Transaction.fromJson(doc.data()))
                    .toList();
                final tiles =
                    transactions.map((e) => _buildTransactionTile(e)).toList();
                return Container(
                  child: ListView(
                    children:
                        ListTile.divideTiles(context: context, tiles: tiles)
                            .toList(),
                  ),
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionCreation(),
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

  List<ChartValue> getChartValue(List<Transaction> transactions,
      Map<String, String> transactionToCategory) {
    final controller = Provider.of(context);
    final Map<String, int> chartV = {};
    for (var transaction in transactions) {
      if (!transaction.income) {
        continue;
      }
      final category = transactionToCategory[transaction.transactionId]!;
      if (chartV[category] == null) {
        chartV[category] = transaction.amount;
      } else {
        chartV[category] = chartV[category]! + transaction.amount;
      }
    }
    final List<ChartValue> res = [];
    chartV.forEach((key, value) {
      res.add(ChartValue(key, value));
    });
    return res;
  }

  Widget _buildTransactionTile(Transaction transaction) {
    String isIncome = '';
    transaction.income ? isIncome = '+' : isIncome = '-';
    final controller = Provider.of(context);

    return ListTile(
        title: StreamBuilder(
          stream: controller
              .getCategoryDocumentById(transaction.categoryId)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<fire.DocumentSnapshot<Map<String, dynamic>>>
                  snapshot) {
            if (snapshot.hasData) {
              final document = snapshot.data!.data();
              Category category;
              if (document == null) {
                category = Category("Uncategorized");
              }
              category = Category.fromJson(document!);
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
          ).then((value) => setState(() {}));
        });
  }
}

class ChartValue {
  final String category;
  final int amount;

  ChartValue(this.category, this.amount);
}
