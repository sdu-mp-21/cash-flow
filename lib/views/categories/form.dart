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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _categoryNameController,
                decoration: const InputDecoration(hintText: "Category name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category name is empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _createCategory();
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

  Future _createCategory() async {
    final controller = Provider.of(context);
    final categoryName = _categoryNameController.text;
    await controller.createCategory(Category(categoryName));
  }
}
