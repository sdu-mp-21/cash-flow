import 'package:final_project/provider.dart';
import 'package:flutter/material.dart';
import 'package:final_project/views/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        home: LoginScreen(),
      ),
    );
  }
}
