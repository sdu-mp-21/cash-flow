import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';

class CategoryCreation extends StatefulWidget {
  const CategoryCreation({Key? key}) : super(key: key);

  @override
  _CategoryCreationState createState() => _CategoryCreationState();
}

class _CategoryCreationState extends State<CategoryCreation> {
  final _categoryNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: _categoryNameController,
                decoration: const InputDecoration(
                  hintText: "Category name",
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await _createCategory();
                    Navigator.pop(context);
                  },
                  child: const Text('Submit')),
            ],
          )),
    );
  }

  Future _createCategory() async {
    final controller = Provider.of(context);
    final categoryName = _categoryNameController.text;
    await controller.createCategory(Category(categoryName));
  }
}
