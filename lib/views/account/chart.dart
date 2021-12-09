import 'package:flutter/material.dart';
import 'package:cash_flow/provider.dart';
import 'package:cash_flow/models/models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionsChart extends StatefulWidget {
  const TransactionsChart({Key? key}) : super(key: key);

  @override
  State<TransactionsChart> createState() => _TransactionsChartState();
}

class _TransactionsChartState extends State<TransactionsChart> {
  String dropdownValue = 'Outcome';
  @override
  Widget build(BuildContext context) {
    bool isIncome = dropdownValue == 'Income';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>["Income", "Outcome"]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
          StreamBuilder(
            stream: streamChartValue(context, isIncome),
            builder: (BuildContext context,
                AsyncSnapshot<List<ChartValue>> snapshot) {
              if (!snapshot.hasData) return const Text('');
              return SfCircularChart(
                title: ChartTitle(text: "transaction amount chart"),
                legend: Legend(isVisible: true),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CircularSeries>[
                  DoughnutSeries<ChartValue, String>(
                      dataSource: snapshot.data!,
                      xValueMapper: (ChartValue data, _) => data.category,
                      yValueMapper: (ChartValue data, _) => data.amount,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      enableTooltip: true)
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<ChartValue> getChartValue(List<Transaction> transactions,
      Map<String, String> transactionToCategory) {
    final Map<String, int> chartV = {};
    for (var transaction in transactions) {
      String category;
      if (transactionToCategory.containsKey(transaction.transactionId)) {
        category = transactionToCategory[transaction.transactionId]!;
      } else {
        category = "Uncategorized";
      }
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

  Stream<List<ChartValue>> streamChartValue(
      BuildContext context, bool isIncome) async* {
    final controller = Provider.of(context);
    await for (final transactions
        in controller.getTransactionsStream(income: isIncome)) {
      await for (final categories in controller.getCategoriesStream()) {
        Map<String, String> transactionToCategory =
            createTransactionToCategory(transactions, categories);
        yield getChartValue(transactions, transactionToCategory);
      }
    }
  }

  Map<String, String> createTransactionToCategory(
      List<Transaction> transactions, List<Category> categories) {
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
    return transactionToCategory;
  }
}

class ChartValue {
  final String category;
  final int amount;

  ChartValue(this.category, this.amount);
}
