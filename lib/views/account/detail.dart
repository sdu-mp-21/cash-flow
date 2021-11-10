import 'package:final_project/models/models.dart';
import 'package:final_project/provider.dart';
import 'package:flutter/material.dart';

class AccountDetail extends StatelessWidget {
  late Account account;
  AccountDetail(this.account, {Key? key}) : super(key: key);

  Account getAccount() {
    return account;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cash Flow"),
      ),
      body: Column(
        children: [
          AccountInfo(account),
          FutureBuilder(
            future: controller.getTransactionsByAccount(account),
            builder: (BuildContext context,
                AsyncSnapshot<List<Transaction>> snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final elem = data[index];
                    return TransactionTile(elem: elem);
                  },
                );
              } else {
                return const Text("");
              }
            },
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
            future: controller.getCategory(elem.categoryId),
            builder: (BuildContext context, AsyncSnapshot<Category> snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.categoryName);
              } else {
                return const Text("");
              }
            },
          ),
          subtitle: Text(elem.createdAt),
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
