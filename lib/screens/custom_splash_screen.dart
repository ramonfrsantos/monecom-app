import 'package:flutter/material.dart';
import 'package:monecom/main.dart';
import 'package:splashscreen/splashscreen.dart';

import 'base_screen.dart';

class CustomSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      useLoader: false,
      seconds: 3,
      routeName: "/",
      navigateAfterSeconds: BaseScreen(),
      title: Text(
        'Mon&Com',
        style: TextStyle(
          color: shrinePurple900,
          fontSize: 70,
          fontFamily: 'UniSans-Heavy',
        ),
      ),
      image: Image.asset(
        'assets/images/logoApp.png',
        alignment: Alignment.center,
      ), //log
      photoSize: 50, // o
      backgroundColor: Colors.white,
    );
  }
}
