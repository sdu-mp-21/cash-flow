import 'package:final_project/models/models.dart';
import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/views/home.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();

  void initState() {
    Firebase.initializeApp();
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
                hintText: "Email",
              ),
              controller: _usernameController,
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Password",
              ),
              controller: _passwordController,
              obscureText: true,
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()))
                          .then((value) => setState(() {}));
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
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Failed login'),
                content: Text('Empty fields'),
              ));
      return false;
    }

    final loggedIn = await controller.loginUser(User(username, password));
    if (loggedIn) {
      return true;
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Failed login'),
              content: Text('Incorrect username or password'),
            ));

    return false;
  }

  Future _registerUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final controller = Provider.of(context);

    if (username == '' || password == '') {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Failed registration'),
                content: Text('Empty fields'),
              ));
      return false;
    }

    final validUsername =
        await controller.registerUser(User(username, password));
    if (validUsername) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Successful registration'),
                content: Text('Username : $username'),
              ));
      _clearTextFields();
    } else {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
              title: Text('Failed registration'),
              content: Text('Such username already exists')));
    }
  }

  void _clearTextFields() {
    _usernameController.clear();
    _passwordController.clear();
  }
}
