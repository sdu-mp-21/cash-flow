import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:flutter/services.dart';

// changed to stateful cause stateless doesn't see the context from other functions
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add transaction"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _amountController,
                decoration: const InputDecoration(
                  hintText: "Money amount",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Money amount is empty';
                  }
                  return null;
                },
              ),
              // SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "Description",
                ),
              ),
              const SizedBox(height: 15),
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
                    if (_formKey.currentState!.validate()) {
                      await _createTransaction();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDropdown() {
    final controller = Provider.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Account:',
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
        const Text('Category:',
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
                return const Text("Loading");
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> _createTransaction() async {
    final controller = Provider.of(context);

    final int amount = int.parse(_amountController.text);

    await controller.createTransaction(
        Transaction(amount, isIncome, _descriptionController.text),
        selectedAccount!,
        selectedCategory!);
  }
}
