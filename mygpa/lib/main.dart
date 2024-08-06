import 'package:flutter/material.dart';
import 'package:mygpa/pages/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
        debugShowCheckedModeBanner: false,
        //theme: ThemeData(),
        //home: HomePage(),
        //home: SetupPage(),
        //home: RegisterPage(),
        home: SplashScreen(),
        //home: const DonePage(),
        //home: const AboutApp(),

    );
  }

}

