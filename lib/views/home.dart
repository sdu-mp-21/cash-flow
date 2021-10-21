import 'package:flutter/material.dart';

import 'package:final_project/views/login_screen.dart';
import 'package:final_project/views/profile_screen.dart';
import 'package:final_project/views/create_screen.dart';
import 'package:final_project/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final _navBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.add), label: 'add'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
  ];

  final _routes = <Widget>[
    CreateScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.authorized() ? controller.user!.username : ''),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text("Login"),
          )
        ],
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
