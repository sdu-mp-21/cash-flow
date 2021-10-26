import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';

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
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    super.initState();
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
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Username",
              ),
              controller: _usernameController,
            ),
            ElevatedButton(
              onPressed: () async {
                await _authUser();
                Navigator.pop(context);
              },
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }

  Future _authUser() async {
    final username = _usernameController.text;
    final controller = Provider.of(context);

    if (username == '') {
      return;
    }

    await controller.registerUser(username);
  }
}
