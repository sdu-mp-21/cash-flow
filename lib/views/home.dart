import 'package:flutter/material.dart';

import 'package:final_project/views/menu_screen.dart';
import 'package:final_project/views/transaction/list.dart';
import 'package:final_project/views/account/list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final _navBarItems = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.account_balance),
      label: 'accounts',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.compare_arrows),
      label: 'transactions',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.menu),
      label: 'menu',
    ),
  ];

  final _routes = <Widget>[
    const AccountsScreen(),
    const TransactionsScreen(),
    const MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CashFlow'),
      ),
      body: Padding(
        child: _routes[_currentIndex],
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      ),
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
