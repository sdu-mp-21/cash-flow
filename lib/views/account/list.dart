import 'package:final_project/models/models.dart';
import 'package:final_project/views/account/creation.dart';
import 'package:final_project/views/account/detail.dart';
import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';

class AccountList extends StatefulWidget {
  const AccountList({Key? key}) : super(key: key);

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: FutureBuilder(
            future: _buildAccountList(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  // set the height to container, cause nester columns trigger overflow error
                  height: 300,
                  child: ListView(children: snapshot.data!),
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
                  builder: (context) => AccountCreation(),
                ),
              ).then((value) => setState(() {}));
            },
            child: const Text("Add account"),
          ),
        ),
      ],
    );
  }

  Future<List<Widget>> _buildAccountList() async {
    final accounts = await Provider.of(context).getAccounts();
    final tiles = <Widget>[];
    accounts.forEach((account) {
      tiles.add(_buildAccountTile(account));
    });
    return tiles;
  }

  Widget _buildAccountTile(Account account) {
    return ListTile(
      title: Text(account.account_name),
      trailing: Text(account.balance.toString()),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountDetail(),
          ),
        );
      },
    );
  }
}
