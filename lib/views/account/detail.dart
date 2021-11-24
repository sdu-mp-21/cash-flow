import 'package:final_project/models/models.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/views/transaction/list.dart';
import 'package:flutter/material.dart';

class AccountDetail extends StatelessWidget {
  final Account account;

  const AccountDetail(this.account, {Key? key}) : super(key: key);

  Account getAccount() {
    return account;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cash Flow"),
      ),
      body: Column(
        children: [
          AccountInfo(account),
          Expanded(
            child: TransactionsView(
              account: account,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    Key? key,
    required this.elem,
  }) : super(key: key);

  final Transaction elem;

  @override
  Widget build(BuildContext context) {
    String isIncome = '';
    elem.income ? isIncome = '+' : isIncome = '-';
    final controller = Provider.of(context);
    return Column(
      children: [
        const Divider(
          thickness: 1.5,
        ),
        ListTile(
          title: FutureBuilder(
            future: controller.getCategoryById(elem.categoryId),
            builder: (BuildContext context, AsyncSnapshot<Category> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.categoryName);
              } else {
                return const Text("");
              }
            },
          ),
          subtitle: Text(elem.createdTime),
          trailing: Text(
            "$isIncome ${elem.amount}\$",
            style: elem.income
                ? const TextStyle(color: Colors.green, fontSize: 15)
                : const TextStyle(color: Colors.red, fontSize: 15),
          ),
        )
      ],
    );
  }
}

class AccountInfo extends StatelessWidget {
  final Account account;

  const AccountInfo(
    this.account, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                account.accountName,
                style: const TextStyle(fontSize: 26.0),
              ),
            ),
          ),
          Center(
            child: Text(
              "${account.balance}",
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
