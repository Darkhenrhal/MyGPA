import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:mygpa/pages/settings.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class DoneSettingsPage extends StatefulWidget {
  const DoneSettingsPage({super.key});

  @override
  DoneSettingsPageState createState() => DoneSettingsPageState();
}

class DoneSettingsPageState extends State<DoneSettingsPage> {
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
            child: Lottie.asset('assets/animation/doneanimation.json', height: 300, width: 300),
          ),
        ],
      ),
      nextScreen: const SettingsPage(),
      duration: 2000,
      backgroundColor: const Color(0xffFEF7FF),
      splashIconSize: 3000,
    );
  }
}
