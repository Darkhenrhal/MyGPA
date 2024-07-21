
import 'package:flutter/material.dart';
import 'package:mygpa/databasehelper.dart';
import 'package:mygpa/user.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool showProfileContainer = false;
  bool showGradingMethodContainer = false;
  Map<String, dynamic>? _courseWeightMap;
  late Future<int> _totalSemesters;
  late Future<int> _totalCourseCredits;
  late Future<String?> _email;
  late Future<String?> _name;
  late String name;
  late String email;
  late int totalCourseCredits;
  late int totalSemesters;
  late bool defaultGrading;
  late bool customGrading;
  late Future<double> _currentGPA;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userTotalSemesterController = TextEditingController();
  final TextEditingController userTotalCreditController = TextEditingController();

  @override
  void clear(){
    userNameController.clear();
    userEmailController.clear();
    userTotalCreditController.clear();
    userTotalSemesterController.clear();
  }

  @override
  void initState() {
    super.initState();
    asignDetails();
    _name = _dbHelper.getName();
    _email = _dbHelper.getEmail();
    _totalSemesters = _dbHelper.getTotalSemesters();
    _totalCourseCredits = _dbHelper.getTotalCourseCredits();
    _currentGPA = _dbHelper.getCurrentGPA();
    _dbHelper.retrieveDefaultGradeWeights().then((value) {
      setState(() {
        _courseWeightMap = value;
      });
    }).catchError((error) {
      print('Error retrieving default grade weights: $error');
      setState(() {
        _courseWeightMap = {};
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: _buildSettingsPage(),
          ),
        ),
      ),
    );
  }

  Future<void> asignDetails() async {
    try {
      String? emailFromFuture = await _dbHelper.getEmail();
      String? nameFromFuture=await _dbHelper.getName();
      int? totalCourseCreditsFromFuture=await _dbHelper.getTotalCourseCredits();
      int? totalSemestersFromFuture=await _dbHelper.getTotalSemesters();

      // Assign the value to a non-nullable String variable
      name = nameFromFuture ?? '';
      email = emailFromFuture ?? '';
      totalSemesters = totalSemestersFromFuture ?? 0;
      totalCourseCredits = totalCourseCreditsFromFuture ?? 0;

      // You can now use the `email` variable
      print('Email: $email');
    } catch (error) {
      print('Error fetching email: $error');
    }
  }


  Future<void> _updateUserDetails() async {
    int userId = 1;
    List<User> users = await _dbHelper.getUsers();
    String newName = userNameController.text.trim();
    String newEmail = userEmailController.text.trim();
    int newTotalCourseCredits = int.parse(userTotalCreditController.text.trim());
    int newTotalSemesters = int.parse(userTotalSemesterController.text.trim());

    User? existingUser;
    try {
      existingUser = users.firstWhere((user) => user.id == userId);
      print(existingUser.name);
    } catch (e) {
      existingUser = null;
    }

    if (existingUser != null) {
      double sumOfMultiplyOfWeightCredit = await _dbHelper.calculateSumOfMultiplyOfWeightCredit();
      int sumOfCurrentTotalCredits = await _dbHelper.getCurrentTotalCourseCredits();
      // Here add update methods for the grades
      Map<String, dynamic> newCustomGradeValue = existingUser.customGradeWeights;

      User updatedUser = User(
        id: existingUser.id,
        name: newName,
        email: newEmail,
        currentGPA: existingUser.currentGPA,
        totalSemesters: newTotalSemesters,
        gpaMethod: existingUser.gpaMethod,
        totalCourseCredits: newTotalCourseCredits,
        customGradeWeights: newCustomGradeValue,
        defaultGradeWeights: existingUser.defaultGradeWeights,
      );

      await _dbHelper.updateUser(updatedUser);
      setState(() {
        _currentGPA = _dbHelper.getCurrentGPA();
      });

      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('User details updated successfully')),
        );
      }
      print("User updated successfully");
    } else {
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
      }
    }
  }


  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Settings',
        style: TextStyle(
          color: Color(0xff2b2b2b),
          fontSize: 25,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      backgroundColor: const Color(0xffffffff),
      centerTitle: false,
      elevation: 0,
      actions: [
        GestureDetector(
          child: Container(
            width: 35,
            height: 35,
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu), // Use your menu icon here
              onPressed: () {
                // Handle menu button tap
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsPage() {
    return Column(
      children: <Widget>[
        Image.asset(
          'assets/images/settings.gif',
          height: 250,
          width: 250,
        ),
        Container(
          margin: const EdgeInsets.only(left: 5, right: 20, top: 20),
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Update Profile',
                  style: TextStyle(
                    color: Color(0xff2b2b2b),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    showProfileContainer = !showProfileContainer;
                    showGradingMethodContainer = false;
                  });
                },
              ),
              if (showProfileContainer) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child:  _buildProfileContainer(),

                )
              ],
              ListTile(
                title: const Text(
                  'Update Grading Method',
                  style: TextStyle(
                    color: Color(0xff2b2b2b),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    showGradingMethodContainer = !showGradingMethodContainer;
                    showProfileContainer = false; // Hide profile container
                  });
                },
              ),
              if (showGradingMethodContainer) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child:_buildGradingMethodContainer(),
                )
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContainer() {
    userNameController.text=name.toString();
    userEmailController.text=email.toString();
    userTotalCreditController.text=totalCourseCredits.toString();
    userTotalSemesterController.text=totalSemesters.toString();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff2b2b2b), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 6),
          _buildTextField('Name', 'Enter Name', userNameController),
          const SizedBox(height: 15),
          _buildTextField('Email', 'Enter Email', userEmailController),
          const SizedBox(height: 15),
          _buildTextField('Total Semesters', 'Enter Total Semesters', userTotalSemesterController),
          const SizedBox(height: 15),
          _buildTextField('Total Credits', 'Enter Total Credits', userTotalCreditController),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return const Color(0xff34312D); // Color when pressed
                }
                return const Color(0xff34312D); // Default background color
              }),
              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                return Colors.white; // Text color
              }),
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(
                    color: Color(0xff2b2b2b),
                    width: 3,
                  ),
                ),
              ),
            ),
            onPressed: () async {
              // Navigator.of(context).pop();
              await _confirmUpdateCourseDialog(context);
            },
            child: const Text(
              'Update Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmUpdateCourseDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Update Profile'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to update your profile?',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff2b2b2b)
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return const Color(0xffE1E1E1);
                  }
                  return Colors.white;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  return Colors.white;
                }),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: Color(0xff2b2b2b),
                      width: 3,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return const Color(0xff34312D);
                  }
                  return const Color(0xff2b2b2b);
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  return Colors.white;
                }),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      color: Color(0xff2b2b2b),
                      width: 3,
                    ),
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _updateUserDetails();
                initState();
              },
              child: const Text(
                'Update',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  Widget _buildGradingMethodContainer() {
    if (_courseWeightMap == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff2b2b2b), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          for (var entry in _courseWeightMap!.entries)
            _buildTextFieldGrade(entry.key, 'Weight for ${entry.key}', entry.value.toString()),
        ],
      ),
    );
  }

  TextField _buildTextField(String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: const Color(0xff2b2b2b),
      decoration: InputDecoration(
        labelText: label,
        fillColor: const Color(0xffE1E1E1),
        hintText: hint,
        labelStyle: _labelTextStyle,
        floatingLabelStyle: _floatingLabelStyle,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Color(0xff2b2b2b)),
        ),
      ),
    );
  }


  Column _buildTextFieldGrade(String label, String hint, String gradeVal) {
    TextEditingController controller = TextEditingController(text: gradeVal);

    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        TextField(
          cursorColor: const Color(0xff2b2b2b),
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            fillColor: const Color(0xffE1E1E1),
            hintText: hint,
            labelStyle: _labelTextStyle,
            floatingLabelStyle: _floatingLabelStyle,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Color(0xff2b2b2b)),
            ),
          ),
        ),
      ],
    );
  }


  static const TextStyle _labelTextStyle = TextStyle(
    color: Color(0xff2b2b2b),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 15,
  );

  static const TextStyle _floatingLabelStyle = TextStyle(
    color: Color(0xff2b2b2b), // Set label color when focused
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
  );

  static const TextStyle _buttonTextStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );
}

