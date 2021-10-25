import 'package:flutter/material.dart';

class AccountCreation extends StatelessWidget {
  const AccountCreation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cash Flow"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "account name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "balance",
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}
