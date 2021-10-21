import 'package:flutter/material.dart';
import 'controllers/controller.dart';

class Provider extends InheritedWidget {
  final controller = Controller();
  Provider({Key? key, required child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static Controller of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<Provider>();
    return provider!.controller;
  }
}