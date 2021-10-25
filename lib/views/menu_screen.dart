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

  void initState() {
    readFromJSON();
    super.initState();
  }

  Future readFromJSON() async {
    print('readdd');

    try {
      String s = await DefaultAssetBundle.of(context)
          .loadString('assets/users.json');
      setState(() {
        Provider.of(context).registerUser(User(s));
      });
    } catch(e) {
      print(e);
    }
  }

  Widget _buildMenu() {
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
            Provider.of(context).user.username,
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()))
                    // added then callback to rebuild profile after logging in, otherwise it would not work
                    .then((value) => setState(() {}));
              },
              child: Icon(Icons.login)),
        ],
      ),
    );
  }
}
