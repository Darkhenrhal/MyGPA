import 'package:flutter/material.dart';
import 'package:mygpa/databasehelper.dart';
import 'package:mygpa/user.dart';
import 'package:mygpa/pages/setup.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _registerUser(BuildContext context) async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name and email')),
      );
      return;
    }

    User newUser = User(
      name: name,
      email: email,
      currentGPA: 0,
      totalSemesters: 0,
      totalCourseCredits: 0,
      gpaMethod: "default",
      customGradeWeights: {
        'A+': 4.0,
        'A': 4.0,
        'A-': 3.7,
        'B+': 3.3,
        'B': 3.0,
        'B-': 2.7,
        'C+': 2.3,
        'C': 2.0,
        'C-': 1.7,
        'D+': 1.3,
        'D': 1.0,
        'E': 0.0,
        'F': 0.0,
      },
      defaultGradeWeights: {
        'A+': 4.0,
        'A': 4.0,
        'A-': 3.7,
        'B+': 3.3,
        'B': 3.0,
        'B-': 2.7,
        'C+': 2.3,
        'C': 2.0,
        'C-': 1.7,
        'D+': 1.3,
        'D': 1.0,
        'E': 0.0,
        'F': 0.0,
      },
    );

    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      int userId = await dbHelper.insertUser(newUser);

      if (userId != 0) {
        print('User Registered: ' + newUser.name);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SetupPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to register. Please try again.')),
        );
      }
    } catch (exception) {
      print('Error inserting user: $exception');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: buildRegisterPage(context),
          ),
        ),
      ),
    );
  }

  Container buildRegisterPage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/register.gif',
            height: 250,
            width: 250,
          ),
          const SizedBox(height: 20),
          const Text(
            'Let\'s get in...',
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: nameController,
            cursorColor: const Color(0xff2b2b2b),
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
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
          TextField(
            controller: emailController,
            cursorColor: const Color(0xff2b2b2b),
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
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
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              _registerUser(context);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color(0xff2b2b2b); // Color when pressed
                  }
                  return const Color(0xff2b2b2b); // Default color
                },
              ),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 45, vertical: 8),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            child: const Text(
              'Next',
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
