import 'package:flutter/material.dart';

class AccountDetail extends StatelessWidget {
  const AccountDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cash Flow"),
      ),
      body: Column(
        children: [
          AccountInfo(),
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
  const AccountInfo({
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
                "AccountName",
                style: TextStyle(fontSize: 26.0),
              ),
            ),
          ),
          Center(
            child: Text(
              "AccountBalance",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
