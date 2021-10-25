import 'package:flutter/material.dart';

import 'package:final_project/views/menu_screen.dart';
import 'package:final_project/views/transaction_screen.dart';
import 'package:final_project/views/account/list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final _navBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
        icon: Icon(Icons.account_balance), label: 'accounts'),
    BottomNavigationBarItem(
        icon: Icon(Icons.compare_arrows), label: 'transactions'),
    BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'menu'),
  ];

  final _routes = <Widget>[
    AccountList(),
    TransactionScreen(),
    MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CashFlow'),
      ),
      body: _routes[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
