import 'package:final_project/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:final_project/provider.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  Map<String, int> categories = <String, int>{};

  final moneyController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [],
      ),
    );
  }

  void addTransaction() {
    if (moneyController.text == '' || categoryController.text == '') {
      return;
    }

    int moneyAmount = int.parse(moneyController.text);
    String categoryName = categoryController.text;

    setState(() {});
    moneyController.clear();
    categoryController.clear();
  }
}
