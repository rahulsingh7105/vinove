//new code
import 'package:flutter/material.dart';
import 'member_screen.dart';  // Import the MemberScreen class

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Location and Route App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MemberScreen(),  // Start with the MemberScreen
    );
  }
}

