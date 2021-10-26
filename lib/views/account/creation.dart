import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';

// changed to stateful cause stateless doesn't see the context from other functions
class AccountCreation extends StatefulWidget {
  const AccountCreation({Key? key}) : super(key: key);

  @override
  _AccountCreationState createState() => _AccountCreationState();
}

class _AccountCreationState extends State<AccountCreation> {
  final _accountNameController = TextEditingController();
  final _balanceController = TextEditingController();

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
              controller: _accountNameController,
              decoration: InputDecoration(
                hintText: "account name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _balanceController,
              decoration: InputDecoration(
                hintText: "balance",
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _createAccount();
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }

  Future _createAccount() async {
    final controller = Provider.of(context);
    final accountName = _accountNameController.text;
    final int balance = int.parse(
        _balanceController.text != '' ? _balanceController.text : '0');

    await controller.createAccount(Account(accountName, balance));
  }
}
