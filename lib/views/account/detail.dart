import 'package:final_project/models/models.dart';
import 'package:final_project/views/transaction/list.dart';
import 'package:flutter/material.dart';

class AccountDetail extends StatelessWidget {
  final Account account;

  const AccountDetail(this.account, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account detail'),
      ),
      body: Column(
        children: [
          TweenAnimationBuilder(
            child: AccountInfo(account),
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            builder: (_, double _val, child) {
              return Opacity(
                opacity: _val,
                child: Padding(
                  padding: EdgeInsets.only(top: _val * 50),
                  child: child,
                ),
              );
            },
          ),
          Expanded(
            child: TweenAnimationBuilder(
              child: TransactionsList(
                account: account,
              ),
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (_, double _val, child) {
                return Opacity(
                  opacity: _val,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      _val * 50,
                      0,
                      _val * 50,
                      0,
                    ),
                    child: child,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountInfo extends StatelessWidget {
  final Account account;

  const AccountInfo(
    this.account, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            account.accountName,
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'balance: ${account.balance} \$',
            style: const TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
