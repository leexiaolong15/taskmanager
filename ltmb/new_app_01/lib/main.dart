import 'package:flutter/material.dart';
import 'package:new_app_01/userMS_API/view/UserListScreen.dart'; // Sửa từ app_02 thành new_app

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(),
    );
  }
}