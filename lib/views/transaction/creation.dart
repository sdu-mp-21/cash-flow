import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';

// changed to stateful cause stateless doesn't see the context from other functions
class TransactionCreation extends StatefulWidget {
  const TransactionCreation({Key? key}) : super(key: key);

  @override
  _TransactionCreationState createState() => _TransactionCreationState();
}

class _TransactionCreationState extends State<TransactionCreation> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

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
              keyboardType: TextInputType.number,
              controller: _amountController,
              decoration: InputDecoration(
                hintText: "account name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "balance",
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _createTransaction();
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }

  Future _createTransaction() async {
    final controller = Provider.of(context);
    final int amount = int.parse(
        _amountController.text != '' ? _amountController.text : '0');

    // await controller.createTransaction();
  }
}
