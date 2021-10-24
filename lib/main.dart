import 'package:final_project/provider.dart';
import 'package:flutter/material.dart';
import './views/home.dart';

void main() {
    runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        home: Home(),
      ),
    );
  }
}
