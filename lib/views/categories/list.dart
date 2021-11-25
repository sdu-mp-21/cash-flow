import 'package:final_project/models/models.dart';
import 'package:flutter/material.dart';
import 'package:final_project/views/categories/form.dart';
import 'package:final_project/provider.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
                child: const Icon(Icons.add),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoryCreation()),
                  ).then((value) => setState(() {}));
                }),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: controller.getCategoriesStream(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Category>> snapshot) {
          var categories = [];
          if (snapshot.hasData) {
            categories = snapshot.data!;
          }
          final tiles = categories.map((e) => _buildCategoryTile(e)).toList();
          return ListView(
            children:
                ListTile.divideTiles(context: context, tiles: tiles).toList(),
          );
        },
      ),
    );
  }

  Widget _buildCategoryTile(Category category) {
    return Dismissible(
      key: Key(category.categoryName),
      onDismissed: (direction) async {
        final controller = Provider.of(context);
        await controller.deleteCategory(category);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${category.categoryName} dismissed')));
      },
      background: Container(color: Colors.red),
      child: ListTile(
        title:
            Text(category.categoryName, style: const TextStyle(fontSize: 18)),
        onTap: () {},
      ),
    );
  }
}
