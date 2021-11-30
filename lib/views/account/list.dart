import 'package:final_project/models/models.dart';
import 'package:final_project/views/account/chart.dart';
import 'package:final_project/views/account/form.dart';
import 'package:final_project/views/account/detail.dart';
import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/views/categories/list.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Accounts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AccountForm(),
                  ),
                ).then((value) => setState(() {}));
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildAccountsList(),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TransactionsChart()))
                  .then((value) => setState(() {}));
            },
            child: const Text('Statistics')),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CategoriesList()))
                  .then((value) => setState(() {}));
            },
            child: const Text('Categories')),
      ],
    );
  }

  Widget _buildAccountsList() {
    final controller = Provider.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: StreamBuilder(
        stream: controller.getAccountsStream(),
        builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final accounts = snapshot.data!;
          final tiles = accounts.map((e) => _buildAccountTile(e)).toList();
          return ListView(
            children:
                ListTile.divideTiles(context: context, tiles: tiles).toList(),
          );
        },
      ),
    );
  }

  Widget _buildAccountTile(Account account) {
    return ListTile(
      title: Text(
        account.accountName,
        style: const TextStyle(fontSize: 18),
      ),
      trailing: Text(
        '${account.balance.toString()} \$',
        style: const TextStyle(fontSize: 18),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountDetail(account),
          ),
        );
      },
    );
  }
}
