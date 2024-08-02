import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:mygpa/pages/home.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class DonePage extends StatefulWidget {
  const DonePage({super.key});

  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/animation/Done.json', height: 300, width: 300),
          ),
        ],
      ),
      nextScreen: const HomePage(),
      duration: 2000,
      backgroundColor: const Color(0xffFEF7FF),
      splashIconSize: 3000,
    );
  }
}
