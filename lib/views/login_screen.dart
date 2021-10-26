import 'package:final_project/models/models.dart';
import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
            TextField(
              decoration: InputDecoration(
                hintText: "Password",
              ),
              controller: _passwordController,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _registerUser();
                  },
                  child: Text("register"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool loggedIn = await _loginUser();
                    if (loggedIn) {
                      Navigator.pop(context);
                    } else {
                      print('invalid login or password');
                    }
                  },
                  child: Text("login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _loginUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final controller = Provider.of(context);

    if (username == '' || password == '') {
      print('input is empty');
      return false;
    }

    final loggedIn = await controller.loginUser(User(username, password));
    return loggedIn;
  }

  Future _registerUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final controller = Provider.of(context);

    if (username == '' || password == '') {
      print('input is empty');
      return;
    }

    await controller.registerUser(User(username, password));
    _usernameController.clear();
    _passwordController.clear();
  }
}
