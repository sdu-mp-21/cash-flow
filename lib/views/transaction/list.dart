import 'package:flutter/material.dart';

import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/views/transaction/creation.dart';
import 'package:final_project/views/transaction/detail.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
              child: FutureBuilder(
                  future: getChartValue(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      return SfCircularChart(
                        title: ChartTitle(text: "transaction amount chart"),
                        legend: Legend(isVisible: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CircularSeries>[
                          DoughnutSeries<ChartValue, String>(
                              dataSource: snapshot.data,
                              xValueMapper: (ChartValue data, _) =>
                                  data.category,
                              yValueMapper: (ChartValue data, _) => data.amount,
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true),
                              enableTooltip: true)
                        ],
                      );
                    } else {
                      return const Text('loading...');
                    }
                  })),
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
                  return const Text('loading...');
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

  Future<List<ChartValue>> getChartValue() async {
    final controller = Provider.of(context);
    final transactions = await controller.getTransactions();
    final Map<String, int> chartV = {};
    for (var transaction in transactions) {
      if (!transaction.income) {
        continue;
      }
      final category = await controller.getCategoryById(transaction.categoryId);
      if (chartV[category.categoryName] == null) {
        chartV[category.categoryName] = transaction.amount;
      } else {
        chartV[category.categoryName] =
            chartV[category.categoryName]! + transaction.amount;
      }
    }
    final List<ChartValue> res = [];
    chartV.forEach((key, value) {
      res.add(ChartValue(key, value));
    });
    return res;
  }

  Future<List<Widget>> _buildTransactionList() async {
    final transactions = await Provider.of(context).getTransactions();
    final tiles = <Widget>[];
    for (var t in transactions) {
      tiles.add(_buildTransactionTile(t));
    }
    return tiles;
  }

  Widget _buildTransactionTile(Transaction transaction) {
    String isIncome = '';
    transaction.income ? isIncome = '+' : isIncome = '-';
    final controller = Provider.of(context);

    return ListTile(
        title: FutureBuilder<Category>(
          future: controller.getCategoryById(transaction.categoryId),
          builder: (BuildContext context, AsyncSnapshot<Category> snapshot) {
            if (snapshot.hasData) {
              Category category = snapshot.data!;
              return Text(category.categoryName);
            } else {
              return Text("Loading...");
            }
          },
        ),
        subtitle: Text(transaction.description),
        trailing: Text(
          "$isIncome" + "${transaction.amount}\$",
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
