import 'package:final_project/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:final_project/provider.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  Map<String, int> categories = <String, int>{};

  final moneyController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          TextField(
              controller: moneyController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Money',
              )),
          TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
              )),
          ElevatedButton(onPressed: addTransaction, child: Icon(Icons.add)),
          ..._showCategories(),
          // _getHttp(),
        ],
      ),
    );
  }

  List<Widget> _showCategories() {
    var result = <Widget>[];
    categories = Provider.of(context).user.categories;

    categories.forEach((key, value) {
      result.add(ListTile(
        title: Text(key),
        subtitle: Text('$value'),
      ));
    });

    return result;
  }

  void addTransaction() {
    if (moneyController.text == '' || categoryController.text == '') {
      return;
    }

    int moneyAmount = int.parse(moneyController.text);
    String categoryName = categoryController.text;

    Provider.of(context).user.addCategory(categoryName, moneyAmount: moneyAmount);

    setState(() {});
    moneyController.clear();
    categoryController.clear();
  }

  // Widget _getHttp() {
  //   var uri = Uri.parse('')
  //
  //
  //   return Text('default text from http request');
  // }
}
