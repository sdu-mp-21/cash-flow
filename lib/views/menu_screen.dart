import 'package:cash_flow/views/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(50),
      alignment: Alignment.center,
      child: _buildMenu(),
    );
  }

  Widget _buildMenu() {
    final controller = Provider.of(context);

    return
      Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children:[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Expanded(
          flex: 3,
              child: Container(
                // color: Colors.green,
                height: 100,
                width: 100,
                child: ClipRRect(
                  child: Image.asset('assets/images/default_user_pic.png'),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),

          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 7,

            child: Column(
              children: [
                Text(
                  controller.user.email,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Text(
                  'user_id: ${controller.user.userId}',
                  style: const TextStyle(fontSize: 18),
                ),],
           ),
          ),
        ],),



        const SizedBox(height: 40),
        ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            child: const Icon(Icons.logout)),
    ],
    );
  }
}
