import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyMeACoffeeButton extends StatelessWidget {
  final String url = 'https://www.buymeacoffee.com/sineth2140g';

  const BuyMeACoffeeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchURL,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2b2b2b), // Button color
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
        ),
        side: const BorderSide(
          color: Colors.white, // Outline color
        ),
      ),
      child: const Text('Buy me a coffee',style: TextStyle(
        color: Colors.white,
      ),),
    );
  }

  void _launchURL() async {
    if (await canLaunch(url)) {
      var bool = await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
