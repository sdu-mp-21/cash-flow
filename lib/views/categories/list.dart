import 'package:final_project/models/models.dart';
import 'package:flutter/material.dart';
import 'package:final_project/views/categories/creation.dart';
import 'package:final_project/provider.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({Key? key}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          Padding(
            padding: EdgeInsets.all(15),
            child: GestureDetector(
                child: Icon(Icons.add),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryCreation()),
                  ).then((value) => setState(() {}));
                }),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: _buildCategoriesList(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                child: ListView(
                  children: snapshot.data!,
                ),
              );
            } else {
              return Text('loading...');
            }
          },
        ),
      ),
    );
  }

  Future<List<Widget>> _buildCategoriesList() async {
    final List<Widget> tiles = <Widget>[];

    final controller = Provider.of(context);
    final categories = await controller.getCategories();
    categories.forEach((c) {
      tiles.add(_buildCategoryTile(c));
    });
    return tiles;
  }

  Widget _buildCategoryTile(Category category) {
    return ListTile(
      title: Text(category.categoryName, style: TextStyle(fontSize: 18)),
      onTap: () {},
    );
  }
}
