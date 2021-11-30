import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';
import 'package:flutter/services.dart';

class AccountForm extends StatefulWidget {
  final Account? account;

  const AccountForm({
    Key? key,
    this.account,
  }) : super(key: key);

  @override
  _AccountFormState createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  late TextEditingController _accountNameController;
  late TextEditingController _balanceController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _accountNameController = TextEditingController();
    _balanceController = TextEditingController();
    if (widget.account != null) {
      _accountNameController.text = widget.account!.accountName;
      _balanceController.text = (widget.account!.balance).toString();
    }
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.account == null ? 'Create' : 'Update'} Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                controller: _accountNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Account name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account name is empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _balanceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Initial balance',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Initial balance is empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    widget.account == null
                        ? await _createAccount()
                        : await _updateAccount();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createAccount() async {
    final accountName = _accountNameController.text;
    final int balance = int.parse(_balanceController.text);

    await Provider.of(context).createAccount(Account(accountName, balance));
  }

  Future<void> _updateAccount() async {
    final accountName = _accountNameController.text;
    final int balance = int.parse(_balanceController.text);

    final updatedAccount = Account(accountName, balance);
    updatedAccount.setAccountId = widget.account!.accountId;

    await Provider.of(context).updateAccount(updatedAccount);
  }
}
