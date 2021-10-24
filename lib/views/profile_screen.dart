import 'package:final_project/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/controllers/controller.dart';
import 'package:final_project/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 250,
      margin: EdgeInsets.all(100),
      alignment: Alignment.center,
      child: _buildProfile(),
    );
  }

  Widget _buildProfile() {
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
          Image(image: AssetImage('assets/images/avatar.png')),
          SizedBox(height: 20),
          Text(
            Provider.of(context).user.username,
            style: TextStyle(),
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
