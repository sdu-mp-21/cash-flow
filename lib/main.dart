import 'package:final_project/provider.dart';
import 'package:final_project/views/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/views/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser != null) {
    User user = FirebaseAuth.instance.currentUser!;
    runApp(MyApp(signed: true, email: user.email!, uid: user.uid));
  } else {
    runApp(const MyApp(signed: false, email: '', uid: ''));
  }
}

class MyApp extends StatelessWidget {
  const MyApp(
      {Key? key, required this.signed, required this.email, required this.uid})
      : super(key: key);
  final bool signed;
  final String email;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Provider(
      signed: signed,
      email: email,
      uid: uid,
      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.red),
        home: signed ? const Home() : const LoginScreen(),
      ),
    );
  }
}
