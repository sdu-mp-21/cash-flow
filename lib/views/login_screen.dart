import 'package:flutter/material.dart';
import 'package:final_project/models/user.dart';
import 'package:final_project/provider.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Username",
            ),
            controller: _usernameController,
          ),
          TextField(
            maxLength: 11,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefix: Text("+"),
              hintText: "Phone",
            ),
            controller: _phoneController,
          ),
          ElevatedButton(
            onPressed: () {
              authUser();
              setState(() {});
              Navigator.pop(context);
            },
            child: Text("Confirm"),
          )
        ],
      ),
    );
  }

  void authUser() {
    final username = _usernameController.text;
    final phoneNumber = _phoneController.text;
    final controller = Provider.of(context);
    controller.setUser = User(username, phoneNumber);
  }
}
