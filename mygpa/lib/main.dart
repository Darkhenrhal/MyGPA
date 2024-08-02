import 'package:flutter/material.dart';
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
        theme: ThemeData(),
        //home:const HomePage(),
        //home:const SetupPage(),
        //home:const RegisterPage(),
        home: const SplashScreen(),
        //home: const DonePage(),
        //home: const AboutApp(),

    );
  }

}

