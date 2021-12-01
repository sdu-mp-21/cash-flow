import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:flutter/services.dart';

class TransactionForm extends StatefulWidget {
  final Transaction? transaction;

  const TransactionForm({
    Key? key,
    this.transaction,
  }) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  Account? selectedAccount;
  Category? selectedCategory;
  bool isIncome = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _amountController.text = '${widget.transaction!.amount}';
      _descriptionController.text = widget.transaction!.description;
      isIncome = widget.transaction!.income;
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (widget.transaction != null) {
      final controller = Provider.of(context);
      await controller
          .getAccountById(widget.transaction!.accountId)
          .then((value) => selectedAccount = value);
      await controller
          .getCategoryById(widget.transaction!.categoryId)
          .then((value) => selectedCategory = value);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  GestureDetector(
                    onTap: () => setState(() => isIncome = true),
                    child: ListTile(
                      title: const Text('Income'),
                      leading: Radio(
                        value: true,
                        groupValue: isIncome,
                        onChanged: (bool? value) =>
                            setState(() => isIncome = true),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => isIncome = false),
                    child: ListTile(
                      title: const Text('Outcome'),
                      leading: Radio(
                        value: false,
                        groupValue: isIncome,
                        onChanged: (bool? value) =>
                            setState(() => isIncome = false),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      widget.transaction == null
                          ? await _createTransaction()
                          : await _updateTransaction();
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
                selectedAccount = Account.empty;
                return DropdownButton<Account>(
                  value: selectedAccount,
                  items: [
                    DropdownMenuItem<Account>(
                      value: selectedAccount,
                      child: Text(selectedAccount!.accountName),
                    ),
                  ],
                );
              }

              List<Account> accounts = snapshot.data!;
              selectedAccount ??= accounts[0];
              return DropdownButton<Account>(
                value: selectedAccount,
                onChanged: (Account? newValue) {
                  setState(() => selectedAccount = newValue);
                },
                items: accounts.map<DropdownMenuItem<Account>>(
                  (Account acc) {
                    return DropdownMenuItem<Account>(
                      value: acc,
                      child: Text(acc.accountName),
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
                selectedCategory = Category.empty;
                return DropdownButton<Category>(
                  value: selectedCategory,
                  items: [
                    DropdownMenuItem<Category>(
                      value: selectedCategory,
                      child: Text(selectedCategory!.categoryName),
                    ),
                  ],
                );
              }

              List<Category> categories = snapshot.data!;
              if (selectedCategory == null ||
                  selectedCategory == Category.empty) {
                selectedCategory = categories[0];
              }
              return DropdownButton<Category>(
                value: selectedCategory,
                onChanged: (Category? newValue) {
                  setState(() => selectedCategory = newValue);
                },
                items: categories.map<DropdownMenuItem<Category>>(
                  (Category ctg) {
                    return DropdownMenuItem<Category>(
                      value: ctg,
                      child: Text(ctg.categoryName),
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

  Future<void> _createTransaction() async {
    if (selectedAccount == Account.empty) {
      await showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('User has no account'),
          content: Text('Please create an account'),
        ),
      );
      return;
    }
    await Provider.of(context).createTransaction(
      Transaction(
        int.parse(_amountController.text),
        isIncome,
        _descriptionController.text,
      ),
      selectedAccount!,
      selectedCategory!,
    );
    Navigator.pop(context);
  }

  Future<void> _updateTransaction() async {
    if (selectedAccount == Account.empty) {
      await showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('User has no account'),
          content: Text('Please create an account'),
        ),
      );
      return;
    }

    final newTransaction = Transaction(
      int.parse(_amountController.text),
      isIncome,
      _descriptionController.text,
    );
    newTransaction.setTransactionId = widget.transaction!.transactionId;
    newTransaction.setAccountId = selectedAccount!.accountId;
    newTransaction.setCategoryId = selectedCategory!.categoryId;

    await Provider.of(context)
        .updateTransaction(widget.transaction!, newTransaction);
    Navigator.pop(context);
  }
}
