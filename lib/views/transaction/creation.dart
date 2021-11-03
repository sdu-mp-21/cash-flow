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
  late Account selectedAccount;
  late Category selectedCategory;
  bool isIncome = true;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
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
                hintText: "Money amount",
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "Description",
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('account:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Account>>(
                future: controller.getAccounts(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Account>> snapshot) {
                  if (snapshot.hasData) {
                    List<Account> accounts = (snapshot.data!);
                    selectedAccount = accounts[0];
                    // String dropdownValue = accounts[0].account_name;
                    return DropdownButton<Account>(
                      isExpanded: true,
                      value: selectedAccount,
                      onChanged: (Account? newValue) {
                        setState(() {
                          selectedAccount = newValue!;
                        });
                      },
                      items: accounts
                          .map<DropdownMenuItem<Account>>((Account value) {
                        print(value.account_id);

                        return DropdownMenuItem<Account>(
                          value: value,
                          child: Text(value.account_name),
                        );
                      }).toList(),
                    );
                  } else {
                    return Text("Loading");
                  }
                }),
          ),
          Text('category:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Category>>(
                future: controller.getCategories(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Category>> snapshot) {
                  if (snapshot.hasData) {
                    List<Category> categories = (snapshot.data!);
                    selectedCategory = categories[0];
                    return DropdownButton<Category>(
                      isExpanded: true,
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
                    return Text("Loading");
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ListTile(
                  title: Text("income"),
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
                  title: Text("outcome"),
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
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (await _createTransaction()) {
                  Navigator.pop(context);
                }
              },
              child: Text("Submit"),
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
    if (amount == 0 || description == '') {
      return false;
    }

    await controller.createTransaction(
        selectedAccount,
        Transaction(
            amount, isIncome, description, selectedCategory.categoryId));
    return true;
  }
}
