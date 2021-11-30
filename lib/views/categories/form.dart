import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';

class CategoryForm extends StatefulWidget {
  final Category? category;

  const CategoryForm({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  late TextEditingController _categoryNameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _categoryNameController = TextEditingController();
    if (widget.category != null) {
      _categoryNameController.text = widget.category!.categoryName;
    }
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${widget.category == null ? 'Create' : 'Update'} Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _categoryNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Category name',
                ),
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
                    widget.category == null
                        ? await _createCategory()
                        : await _updateCategory();
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
    final categoryName = _categoryNameController.text;
    await Provider.of(context).createCategory(Category(categoryName));
  }

  Future<void> _updateCategory() async {
    final updatedCategory = Category(_categoryNameController.text);
    updatedCategory.setCategoryId = widget.category!.categoryId;
    await Provider.of(context).updateCategory(updatedCategory);
  }
}
