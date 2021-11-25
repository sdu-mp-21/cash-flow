import 'package:final_project/models/models.dart';
import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';
import 'package:final_project/views/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  RegExp regExpPassword =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{5,}$');
  RegExp regExpUser = RegExp(r'[A-Za-z0-9_]$');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Email",
                // errorText: _validate ? 'Invalid Email' : null, //<--->
              ),
              controller: _usernameController,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Password",
              ),
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _registerUser();
                  },
                  child: const Text("register"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool loggedIn = await _loginUser();
                    if (loggedIn) {
                      Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()))
                          .then((value) => setState(() {}));
                    }
                  },
                  child: const Text("login"),
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
        builder: (_) => const AlertDialog(
          title: Text('Failed login'),
          content: Text('Empty fields'),
        ),
      );
      return false;
    }

    final loggedIn = await controller.loginUser(User(username, password));
    if (loggedIn) {
      return true;
    }

    showDialog(
      context: context,
      builder: (_) => const AlertDialog(
        title: Text('Failed login'),
        content: Text(
          'Incorrect username or password',
        ),
      ),
    );

    return false;
  }

  Future _registerUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final controller = Provider.of(context);

    if (!regExpUser.hasMatch(_usernameController.text)) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Failed registration'),
          content: Text('Invalid Email'),
        ),
      );
      return false;
    }
    if (!regExpPassword.hasMatch(_passwordController.text)) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Failed registration'),
          content: Text('Invalid Password'),
        ),
      );
      return false;
    }

    if (username == '' || password == '') {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Failed registration'),
          content: Text('Empty fields'),
        ),
      );
      return false;
    }

    final validUsername =
        await controller.registerUser(User(username, password));
    if (validUsername) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Successful registration'),
          content: Text('Username : $username'),
        ),
      );
      _clearTextFields();
    } else {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text('Failed registration'),
          content: Text('Such username already exists'),
        ),
      );
    }
  }

  void _clearTextFields() {
    _usernameController.clear();
    _passwordController.clear();
  }
}
