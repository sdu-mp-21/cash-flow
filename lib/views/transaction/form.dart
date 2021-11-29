import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:flutter/services.dart';

// changed to stateful cause stateless doesn't see the context from other functions
class TransactionCreation extends StatefulWidget {
  final Transaction? transaction;
  final Account? account;
  final Category? category;

  const TransactionCreation({
    Key? key,
    this.transaction,
    this.account,
    this.category,
  }) : super(key: key);

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
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (widget.transaction != null) {
      _amountController.text = '${widget.transaction!.amount}';
      _descriptionController.text = widget.transaction!.description;
      selectedAccount = widget.account;
      selectedCategory = widget.category;
      isIncome = widget.transaction!.income;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction == null
            ? 'Add transaction'
            : 'Update transaction'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _amountController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Money amount',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Money amount is empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Description",
                ),
              ),
              const SizedBox(height: 15),
              _buildAccountDropdown(),
              _buildCategoryDropdown(),
              Column(
                children: [
                  ListTile(
                    title: const Text('Income'),
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
                    title: const Text('Outcome'),
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
                  child: const Text('Submit'),
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
        const Text(
          'Account:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            stream: controller.getAccountsStream(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              if (snapshot.data!.isEmpty) {
                final temp = Account('Default Account', 0);
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
                items: accounts.map<DropdownMenuItem<Account>>(
                  (Account value) {
                    return DropdownMenuItem<Account>(
                      value: value,
                      child: Text(value.accountName),
                    );
                  },
                ).toList(),
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
        const Text(
          'Category:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Category>>(
            stream: controller.getCategoriesStream(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              if (snapshot.data!.isEmpty) {
                final temp = Category("Uncategorized");
                return DropdownButton<Category>(
                  value: temp,
                  items: [
                    DropdownMenuItem<Category>(
                      value: temp,
                      child: Text(temp.categoryName),
                    ),
                  ],
                );
              }

              List<Category> categories = (snapshot.data!);
              selectedCategory ??= categories[0];
              return DropdownButton<Category>(
                value: selectedCategory,
                onChanged: (Category? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: categories.map<DropdownMenuItem<Category>>((Category c) {
                  return DropdownMenuItem<Category>(
                    value: c,
                    child: Text(c.categoryName),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _createTransaction() async {
    final controller = Provider.of(context);

    final int amount = int.parse(_amountController.text);

    if (widget.transaction != null) {
      //update
      final updatedTransaction =
          Transaction(amount, isIncome, _descriptionController.text);
      updatedTransaction.setTransactionId = widget.transaction!.transactionId;

      await controller.updateTransaction(
          updatedTransaction, selectedAccount!, selectedCategory!);
    } else {
      await controller.createTransaction(
          Transaction(amount, isIncome, _descriptionController.text),
          selectedAccount!,
          selectedCategory);
    }
  }
}
