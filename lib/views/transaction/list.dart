import 'package:flutter/material.dart';

import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:final_project/views/transaction/creation.dart';
import 'package:final_project/views/transaction/detail.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const TransactionsChart(),
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

class TransactionsChart extends StatelessWidget {
  const TransactionsChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamCharValue(context),
      builder:
          (BuildContext context, AsyncSnapshot<List<ChartValue>> snapshot) {
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
                dataLabelSettings: const DataLabelSettings(isVisible: true),
                enableTooltip: true)
          ],
        );
      },
    );
  }

  List<ChartValue> getChartValue(List<Transaction> transactions,
      Map<String, String> transactionToCategory) {
    final Map<String, int> chartV = {};
    for (var transaction in transactions) {
      if (!transaction.income) {
        continue;
      }
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

  Stream<List<ChartValue>> streamCharValue(BuildContext context) async* {
    final controller = Provider.of(context);
    await for (final transactions in controller.getTransactionsStream()) {
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

class TransactionsView extends StatelessWidget {
  const TransactionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
    return StreamBuilder(
      stream: controller.getTransactionsStream(),
      builder:
          (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
        var transactions = [];
        if (snapshot.hasData) {
          transactions = snapshot.data!;
        }
        final tiles =
            transactions.map((e) => TransactionTile(transaction: e)).toList();
        return ListView(
          children:
              ListTile.divideTiles(context: context, tiles: tiles).toList(),
        );
      },
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

class ChartValue {
  final String category;
  final int amount;

  ChartValue(this.category, this.amount);
}
