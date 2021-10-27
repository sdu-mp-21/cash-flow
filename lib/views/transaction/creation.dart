import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';


// changed to stateful cause stateless doesn't see the context from other functions
class TransactionCreation extends StatefulWidget {
  const TransactionCreation({Key? key}) : super(key: key);

  @override
  _TransactionCreationState createState() => _TransactionCreationState();
}

enum SingingCharacter { income, outcome }

class _TransactionCreationState extends State<TransactionCreation> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _income = true;
  SingingCharacter? _character = SingingCharacter.income;

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
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "account name",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: "balance",
              ),
            ),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: const Text('income'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.income,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      _income = true;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('outcome'),
                leading: Radio<SingingCharacter>(
                  value: SingingCharacter.outcome,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      _income = false;
                    });
                  },
                ),
              ),
            ],
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
    final transactionName = _descriptionController.text;
    final int amount = int.parse(
        _amountController.text != '' ? _amountController.text : '0');

    //await controller.createTransaction(Account("user", 500), Transaction(amount, _income, transactionName));

  }
}
