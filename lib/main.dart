import 'package:flutter/material.dart';
import 'package:phone_number_ip/data_phone.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Info',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DataPhoneScreen(),
    );
  }
}

