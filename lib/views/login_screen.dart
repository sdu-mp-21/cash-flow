import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
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
              hintText: "Name",
            ),
            controller: _nameController,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Surname",
            ),
            controller: _surnameController,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Phone",
            ),
            controller: _phoneController,
          ),
          ElevatedButton(
            onPressed: () {
              print("Submitted");
              print(_nameController.text);
              print(_surnameController.text);
              print(_phoneController.text);
              Navigator.pop(context);
            },
            child: Text("Confirm"),
          )
        ],
      ),
    );
  }
}
