import 'package:flutter/material.dart';
import 'myWidget_02/VD6_DateTimePicker.dart'; // Đảm bảo đường dẫn chính xác

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FormBasicDemo(), // Đảm bảo class này tồn tại trong file import
    );
  }
}