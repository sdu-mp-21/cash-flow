import 'package:flutter/material.dart';
import 'package:final_project/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 250,
      margin: const EdgeInsets.all(100),
      alignment: Alignment.center,
      child: _buildMenu(),
    );
  }

  Widget _buildMenu() {
    final controller = Provider.of(context);

    return Container(
      child: Column(
        children: [
          Text(
            controller.user.email,
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            'user_id: ${controller.user.userId}',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.logout)),
        ],
      ),
    );
  }
}
