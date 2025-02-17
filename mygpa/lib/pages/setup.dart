import 'package:flutter/material.dart';
import 'package:mygpa/databasehelper.dart';
import 'package:mygpa/user.dart';
import 'package:mygpa/pages/done.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  String? dropdownValue = 'Custom'; // Initial dropdown value set to a valid option
  final TextEditingController _semestersController = TextEditingController();
  final TextEditingController _courseCreditsController = TextEditingController();
  late DatabaseHelper dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  Future<void> _updateUserDetails() async {
    int userId = 1;
    List<User> users = await dbHelper.getUsers();

    User? existingUser;
    try {
      existingUser = users.firstWhere((user) => user.id == userId);
    } catch (e) {
      existingUser = null;
    }

    if (existingUser != null) {
      int totalSemesters = int.tryParse(_semestersController.text) ?? 0;
      int totalCourseCredits = int.tryParse(_courseCreditsController.text) ?? 0;

      User updatedUser = User(
        id: existingUser.id,
        name: existingUser.name,
        email: existingUser.email,
        currentGPA: existingUser.currentGPA,
        totalSemesters: totalSemesters,
        gpaMethod: existingUser.gpaMethod,
        totalCourseCredits: totalCourseCredits,
        customGradeWeights: existingUser.customGradeWeights,
        defaultGradeWeights: existingUser.defaultGradeWeights,
      );

      await dbHelper.updateUser(updatedUser);
      //Toast message
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('User details updated successfully')),
      // );
      print("user updated successfully${updatedUser.totalSemesters} and ${updatedUser.totalCourseCredits}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DonePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: buildSetupPage(),
        ),
      ),
    );
  }

  Widget buildSetupPage() {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/setup.gif',
                  height: 225,
                  width: 225,
                ),
                const Text(
                  'Set up your',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    color: Color(0xff6C6C6C),
                  ),
                ),
                const Text(
                  'Academic Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 30,
                    color: Color(0xff2b2b2b),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _semestersController,
                  cursorColor: const Color(0xff2b2b2b),
                  decoration: const InputDecoration(
                    labelText: 'Semesters Count',
                    hintText: 'Enter total semester count',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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
                  controller: _courseCreditsController,
                  cursorColor: const Color(0xff2b2b2b),
                  decoration: const InputDecoration(
                    labelText: 'Course Credits',
                    hintText: 'Enter total course credits',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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
                  onPressed: () async {
                    await _updateUserDetails();

                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return const Color(0xff2b2b2b); // Color when pressed
                        }
                        return const Color(0xff2b2b2b); // Default color
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
                    'Get In',
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
          ),
        ],
      ),
    );
  }
}
