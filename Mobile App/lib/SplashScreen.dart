import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watery/Dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirectToDashboard();
  }

  redirectToDashboard() {
    new Timer(new Duration(seconds: 2), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Text("Splash Screen"),
          ),
        ),
      ),
    );
  }
}
