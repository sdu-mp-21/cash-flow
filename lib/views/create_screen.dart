import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final balance = 0;
  Map<String, int> categories = <String, int>{
    "health": 0,
    "shop": 0,
  };
  final moneyController = TextEditingController();
  final categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            controller: moneyController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Money',
              )),
          TextField(
            controller: categoryController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category',
              )),
          ElevatedButton(onPressed: addTransaction, child: Icon(Icons.add)),
          ...showCategories(),
        ],
      ),
    );
  }

  List<Widget> showCategories() {
    var result = <Widget>[];
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

    int money = int.parse(moneyController.text);
    String category = categoryController.text;

    if(!categories.containsKey(category)) {
      categories[category] = 0;
    }

    categories[category] = (categories[category])! + money;
    setState(() {});
    moneyController.clear();
    categoryController.clear();
  }
}