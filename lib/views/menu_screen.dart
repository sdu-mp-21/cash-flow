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
      margin: const EdgeInsets.all(100),
      alignment: Alignment.center,
      child: _buildMenu(),
    );
  }

  Widget _buildMenu() {
    final controller = Provider.of(context);

    return Column(
      children: [
        Text(
          controller.user.email,
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 20),
        Text(
          'user_id: ${controller.user.userId}',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
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
