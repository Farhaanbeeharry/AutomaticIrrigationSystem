import 'package:flutter/material.dart';
import 'package:watery/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watery',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
