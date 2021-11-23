import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;

// changed to stateful cause stateless doesn't see the context from other functions
class TransactionCreation extends StatefulWidget {
  const TransactionCreation({Key? key}) : super(key: key);

  @override
  _TransactionCreationState createState() => _TransactionCreationState();
}

class _TransactionCreationState extends State<TransactionCreation> {
  final _amountController = TextEditingController(text: "100");
  final _descriptionController = TextEditingController(text: "Money");
  Account? selectedAccount;
  Category? selectedCategory;
  bool isIncome = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add transaction"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: _amountController,
            decoration: const InputDecoration(
              hintText: "Money amount",
            ),
          ),
          // SizedBox(height: 10),
          TextField(
            keyboardType: TextInputType.text,
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: "Description",
            ),
          ),
          SizedBox(height: 15),
          _buildAccountDropdown(),
          _buildCategoryDropdown(),
          Column(
            children: [
              ListTile(
                title: const Text("income"),
                leading: Radio(
                  value: true,
                  groupValue: isIncome,
                  onChanged: (bool? value) {
                    setState(() {
                      isIncome = true;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text("outcome"),
                leading: Radio(
                  value: false,
                  groupValue: isIncome,
                  onChanged: (bool? value) {
                    setState(() {
                      isIncome = false;
                    });
                  },
                ),
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (await _createTransaction()) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDropdown() {
    final controller = Provider.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Account:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: controller.getAccountsStream(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
              if (!snapshot.hasData) {
                final temp = Account("", 0);
                return DropdownButton<Account>(
                  value: temp,
                  items: [
                    DropdownMenuItem<Account>(
                      value: temp,
                      child: Text(temp.accountName),
                    ),
                  ],
                );
              }
              var accounts = snapshot.data!;
              selectedAccount ??= accounts[0];
              return DropdownButton<Account>(
                value: selectedAccount,
                onChanged: (Account? newValue) {
                  setState(() {
                    selectedAccount = newValue!;
                  });
                },
                items: accounts.map<DropdownMenuItem<Account>>((Account value) {
                  return DropdownMenuItem<Account>(
                    value: value,
                    child: Text(value.accountName),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final controller = Provider.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Category:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<Category>>(
            future: controller.getCategories(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
              if (snapshot.hasData) {
                List<Category> categories = (snapshot.data!);
                selectedCategory ??= categories[0];
                return DropdownButton<Category>(
                  value: selectedCategory,
                  onChanged: (Category? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items:
                      categories.map<DropdownMenuItem<Category>>((Category c) {
                    return DropdownMenuItem<Category>(
                      value: c,
                      child: Text(c.categoryName),
                    );
                  }).toList(),
                );
              } else {
                return Text("Loading");
              }
            },
          ),
        ),
      ],
    );
  }

  Future<bool> _createTransaction() async {
    final controller = Provider.of(context);
    if (_amountController.text == '' || _descriptionController.text == '') {
      return false;
    }

    final int amount = int.parse(_amountController.text);

    await controller.createTransaction(
        Transaction(amount, isIncome, _descriptionController.text),
        selectedAccount!,
        selectedCategory!);
    return true;
  }
}
