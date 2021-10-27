import 'package:final_project/models/models.dart';
import 'package:flutter/material.dart';

class AccountDetail extends StatelessWidget {
  late Account account;
  AccountDetail(this.account, {Key? key}) : super(key: key);

  Account getAccount(){
    return this.account;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cash Flow"),
      ),
      body: Column(
        children: [
          AccountInfo(account),
          ListView(
            shrinkWrap: true,
            children: [
              Divider(
                thickness: 1.5,
              ),
              ListTile(
                title: Text("CategoryName 1"),
                trailing: Text("999 тг\n25.10.2021"),
                // tileColor: Colors.black12,
              ),
              Divider(
                thickness: 1.5,
              ),
              ListTile(
                title: Text("CategoryName 2"),
                trailing: Text("999 тг\n25.10.2021"),
                // tileColor: Colors.black12,
              ),
              Divider(
                thickness: 1.5,
              ),
              ListTile(
                title: Text("CategoryName 3"),
                trailing: Text("999 тг\n25.10.2021"),
                // tileColor: Colors.black12,
              ),
              Divider(
                thickness: 1.5,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class AccountInfo extends StatelessWidget {
   late Account account;

  AccountInfo(
    this.account,{
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
                "${account.account_name}",
                style: TextStyle(fontSize: 26.0),
              ),
            ),
          ),
          Center(
            child: Text(
              "${account.balance}",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
