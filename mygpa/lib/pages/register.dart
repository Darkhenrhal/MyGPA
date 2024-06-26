import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center( // Wrap the Column with Center widget
            child: buildRegisterPage(),
          ),
        ),
      ),
    );
  }

  Container buildRegisterPage() {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
        children: <Widget>[
          Image.asset(
            'assets/images/register.gif',
            height: 250,
            width: 250,
          ),
          const SizedBox(height: 20), // Adjusted to remove 'const' for flexibility
          const Text(
            'Let\'s get in...',
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20), // Adjusted to remove 'const' for flexibility
          const TextField(
            decoration: InputDecoration(
              labelText: 'Your name',
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              floatingLabelStyle: TextStyle(
                color: Color(0xff2b2b2b), // Set label color when focused
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set border radius here
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set border radius here
                borderSide: BorderSide(color: Color(0xff2b2b2b)),
              ),
            ),
          ),
          const SizedBox(height: 20), // Adjusted to remove 'const' for flexibility
          const TextField(
            decoration: InputDecoration(
              labelText: 'Your E-mail',
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              floatingLabelStyle: TextStyle(
                color: Color(0xff2b2b2b), // Set label color when focused
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set border radius here
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set border radius here
                borderSide: BorderSide(color: Color(0xff2b2b2b)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {

            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Color(0xff2b2b2b); // Color when pressed
                  }
                  return Color(0xff2b2b2b); // Default color
                },
              ),
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white), // Text color
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 45, vertical: 8),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

