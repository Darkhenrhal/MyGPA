import 'package:flutter/material.dart';
import 'package:mygpa/pages/home.dart';
import 'package:mygpa/pages/register.dart';
import 'package:mygpa/pages/setup.dart';
import 'package:mygpa/pages/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: ThemeData(),
        //home: HomePage(),
        //home: SetupPage(),
        //home: RegisterPage(),
        home: const SplashScreen(),
        //home: const DonePage(),
        //home: const AboutApp(),

    );
  }

}

