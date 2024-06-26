import 'package:mygpa/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // Navigate to the home page after 2 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff2B2B2B), // Dark Gray
              Color(0xff3c3c3c), // Lighter Gray
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: 110,
            height: 110,
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            decoration: const BoxDecoration(

            ),
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              height: 100,
              width: 100,
            ),
          ),
        ),
      ),
    );
  }
}

//if the user already created account then he can log
