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
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
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
        title: isLogin ? const Text('Login') : const Text('Registration'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is empty';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is empty';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : _authButton(isLogin ? 'Login' : 'Register',
                    isLogin ? _onLogin : _onRegister),
            TextButton(
              onPressed: () {
                isLogin = !isLogin;
                setState(() {});
              },
              child: isLogin ? const Text('Register') : const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _authButton(String txt, VoidCallback callback) {
    return ElevatedButton(
      onPressed: callback,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          txt,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      bool loggedIn = await _loginUser();
      setState(() => isLoading = false);
      if (loggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        ).then((value) => setState(() {}));
      }
    }
  }

  Future<bool> _loginUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final controller = Provider.of(context);

    final loginError = await controller.loginUser(User(username, password));
    if (loginError == null) {
      return true;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Failed login'),
        content: Text(loginError),
      ),
    );

    return false;
  }

  Future<void> _onRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      await _registerUser();
      setState(() => isLoading = false);
    }
  }

  Future _registerUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final controller = Provider.of(context);

    final registrationError =
        await controller.registerUser(User(username, password));
    if (registrationError == null) {
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
        builder: (_) => AlertDialog(
          title: const Text('Failed registration'),
          content: Text(registrationError),
        ),
      );
    }
  }

  void _clearTextFields() {
    _usernameController.clear();
    _passwordController.clear();
  }
}
