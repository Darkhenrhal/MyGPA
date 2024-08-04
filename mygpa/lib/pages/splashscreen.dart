import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:mygpa/databasehelper.dart';
import 'package:mygpa/pages/register.dart';
import 'package:mygpa/user.dart';
import 'package:mygpa/pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();

    //_checkUserRegistered();
  }

  Future<void> _checkUserRegistered()async{
    try{
      DatabaseHelper dbHelper=DatabaseHelper();
      List<User> users=await dbHelper.getUsers();

      if (users.isNotEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  const HomePage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  RegisterPage()),
        );
      }
    }catch(exception){
      print('Error checking registered users: $exception');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/animation/loadanimation.json',height: 200,width: 200),
          ),
        ],
      ),
      nextScreen:  RegisterPage(),
      duration: 2500,
      backgroundColor: const Color(0xfffcffff),
      splashIconSize: 200,
    );
  }
}
