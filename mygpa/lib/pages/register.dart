
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: buildRegisterPage(),
      ),
    );
  }

  Container buildRegisterPage(){
    return Container(
      child: const Column(
        children:<Widget> [
          Text(
            'Let\'s you in',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'PlaywriteMX',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Let\'s you in',
            style: TextStyle(
              fontSize: 20,

            ),
          ),
          Text(
            'Let\'s you in',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Let\'s you in',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(

            // controller: _controller,
            decoration: InputDecoration(
              labelText: 'Enter name',
              border: OutlineInputBorder(),

            ),
          ),
        ],
      ),
    );
  }









}

