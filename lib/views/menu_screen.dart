import 'package:flutter/material.dart';

import 'package:final_project/views/login_screen.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/models/models.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 250,
      margin: EdgeInsets.all(100),
      alignment: Alignment.center,
      child: _buildMenu(),
    );
  }

  Widget _buildMenu() {
    final controller = Provider.of(context);

    // if (!controller.authorized()) {
    //   return ElevatedButton(
    //       onPressed: () {
    //         Navigator.push(context,
    //                 MaterialPageRoute(builder: (context) => LoginScreen()))
    //             // added then callback to rebuild profile after logging in, otherwise it would not work
    //             .then((value) => setState(() {}));
    //       },
    //       child: Icon(Icons.login));
    // }

    return Container(
      child: Column(
        children: [
          Text(
            controller.user.username,
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 20),
          Text(
            'user_id: ${controller.user.user_id.toString()}',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                // added then callback after login page pops up from navigator (async)
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()))
                    .then((value) => setState(() {}));
              },
              child: Icon(Icons.login)),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                controller.clearUsers();
              },
              child: Text('admin: clear users')),
        ],
      ),
    );
  }
}