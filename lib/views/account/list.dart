import 'package:final_project/models/models.dart';
import 'package:final_project/views/account/creation.dart';
import 'package:final_project/views/account/detail.dart';
import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/views/categories/list.dart';

class AccountList extends StatefulWidget {
  const AccountList({Key? key}) : super(key: key);

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('accounts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountCreation(),
                      ),
                    ).then((value) => setState(() {}));
                  },
                  child: const Icon(Icons.add),
                  style: const ButtonStyle()),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            child: StreamBuilder(
              stream: controller.getAccountsStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Account>> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox.shrink();
                }
                final accounts = snapshot.data!;
                final tiles =
                    accounts.map((e) => _buildAccountTile(e)).toList();
                return Container(
                  // set the height to container, cause nester columns trigger overflow error
                  height: MediaQuery.of(context).size.height / 3,
                  child: ListView(
                    children:
                        ListTile.divideTiles(context: context, tiles: tiles)
                            .toList(),
                  ),
                );
              },
            ),
          ),
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
