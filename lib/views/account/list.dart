import 'package:final_project/views/account/creation.dart';
import 'package:final_project/views/account/detail.dart';
import 'package:flutter/material.dart';

class AccountList extends StatefulWidget {
  const AccountList({Key? key}) : super(key: key);

  @override
  _AccountListState createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text("Account 1"),
          trailing: Text("800 тг"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountDetail(),
              ),
            );
          },
        ),
        ListTile(
          title: Text("Account 2"),
          trailing: Text("1200 тг"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountDetail(),
              ),
            );
          },
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountCreation(),
                ),
              );
            },
            child: const Text("Add account"),
          ),
        )
      ],
    );
  }
}
