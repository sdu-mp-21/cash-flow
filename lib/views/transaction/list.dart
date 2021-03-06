import 'package:flutter/material.dart';
import 'package:cash_flow/provider.dart';
import 'package:cash_flow/models/models.dart';
import 'package:cash_flow/views/transaction/form.dart';
import 'package:cash_flow/views/transaction/detail.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}


enum isIncome {
  all,
  income,
  outcome
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String dropdownValue = 'All';

  @override
  Widget build(BuildContext context) {
    bool? income = (dropdownValue == 'All') ? null : dropdownValue=='Income';
    return Column(
      children: [
        DropdownButton<String>(
          value: dropdownValue,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: <String>["All", "Income", "Outcome"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
        Expanded(
          child: TransactionsList(income: income),
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
            builder: (context) => const TransactionForm(),
          ),
        );
      },
      child: const Text("Add transaction"),
    );
  }
}

class TransactionsList extends StatelessWidget {
  final Account? account;
  final bool? income;

  const TransactionsList({Key? key, this.account, this.income})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
    return StreamBuilder(
      stream: controller.getTransactionsStream(
          account: account,
          income: income),
      builder:
          (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No transactions'));
        }

        final transactions = snapshot.data!;
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
    return ListTile(
      title: StreamBuilder(
        stream: controller.getCategoryStreamById(transaction.categoryId),
        builder: (BuildContext context, AsyncSnapshot<Category> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          Category category = snapshot.data!;
          return Text(category.categoryName);
        },
      ),
      subtitle: Text(transaction.description),
      trailing: Text(
        (transaction.income ? '+' : '-') + "${transaction.amount}\$",
        style: TextStyle(
            color: transaction.income ? Colors.green : Colors.red,
            fontSize: 15),
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
