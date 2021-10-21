import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
            	shape: BoxShape.circle,
              
            	image: DecorationImage(
            	  image: AssetImage('assets/images/avatar.png'),
            	  fit: BoxFit.fill
            	),
              ),
            ),            
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(      
                border: Border.all(),
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),       
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.person),
                  Text("My Account"),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(      
                border: Border.all(),
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),       
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.notifications),
                  Text("Notifications"),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
            Container(  
              width: 200,
              height: 50,
              decoration: BoxDecoration(      
                border: Border.all(),
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),       
              child: Row(  
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.settings),
                  Text("Settings"),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),  
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(      
                border: Border.all(),
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),       
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.question_answer),
                  Text("Help Center"),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),  
            Container( 
              width: 200,
              height: 50,
              decoration: BoxDecoration(      
                border: Border.all(),
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),        
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.logout),
                  Text("Log Out"),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),  
        ],  
      ),
    );

  }
}
