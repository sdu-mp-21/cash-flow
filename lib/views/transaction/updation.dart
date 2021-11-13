import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';

class TransactionCreation extends StatefulWidget {
  const TransactionCreation({Key? key}) : super(key: key);

  @override
  _TransactionCreationState createState() => _TransactionCreationState();
}

class _TransactionCreationState extends State<TransactionCreation> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  Account? selectedAccount;
  Category? selectedCategory;
  bool isIncome = true;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
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
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('account:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Account>>(
                future: controller.getAccounts(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Account>> snapshot) {
                  if (snapshot.hasData) {
                    List<Account> accounts = (snapshot.data!);
                    selectedAccount ??= accounts[0];
                    return DropdownButton<Account>(
                      value: selectedAccount,
                      onChanged: (Account? newValue) {
                        setState(() {
                          selectedAccount = newValue!;
                        });
                      },
                      items: accounts
                          .map<DropdownMenuItem<Account>>((Account value) {
                        return DropdownMenuItem<Account>(
                          value: value,
                          child: Text(value.accountName),
                        );
                      }).toList(),
                    );
                  } else {
                    return const Text("Loading");
                  }
                },
              ),
            ),
          ]),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('category:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Category>>(
                future: controller.getCategories(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Category>> snapshot) {
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
                      items: categories
                          .map<DropdownMenuItem<Category>>((Category c) {
                        return DropdownMenuItem<Category>(
                          value: c,
                          child: Text(c.categoryName),
                        );
                      }).toList(),
                    );
                  } else {
                    return const Text("Loading");
                  }
                },
              ),
            ),
          ]),
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

  Future<bool> _createTransaction() async {
    final controller = Provider.of(context);

    final int amount =
        int.parse(_amountController.text != '' ? _amountController.text : '0');
    final String description = _descriptionController.text;
    if (amount == 0) {
      return false;
    }

    await controller.createTransaction(
        Transaction(amount, isIncome, description),
        selectedAccount!,
        selectedCategory!);
    return true;
  }
}
