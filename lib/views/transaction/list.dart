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
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Container(
            child: FutureBuilder(
              future: getChartValue(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                          xValueMapper: (ChartValue data,_) => data.category,
                          yValueMapper: (ChartValue data,_) => data.amount, 
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          enableTooltip: true
                       )
                    ],
                  );
                } else {
                  return Text('loading...');
                }
              }
            )
          ),
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

  Future<List<ChartValue>> getChartValue() async{
    final transactions = await Provider.of(context).getTransactions();
    final List<ChartValue> chartV = [];

    transactions.forEach((element) {
      chartV.add(ChartValue(element.description,element.amount));
    });
    return chartV;  
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
        title: FutureBuilder(
          future: controller.getCategory(transaction.category_id),
          builder: (BuildContext context, AsyncSnapshot<Category> snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.categoryName);
            } else {
              return const Text("");
            }
          },
        ),
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

class ChartValue{
    final String category;
    final int amount;
    ChartValue(this.category, this.amount);
}
