
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mygpa/databasehelper.dart';
import 'package:mygpa/pages/aboutapp.dart';
import 'package:mygpa/pages/donesettings.dart';
import 'package:mygpa/pages/home.dart';
import 'package:mygpa/user.dart';

import '../course.dart';
import 'buymeacoffee.dart';


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
  bool showChangeGradeMethod = false;
  Map<String, dynamic>? _courseWeightMap;
  Map<String, TextEditingController> _newGradeControllers = {};
  Map<String, dynamic> _newCourseWeightMap = {};
  late bool customchanged=false;
  late bool gradeMethodChanged=false;
  late Future<int> _totalSemesters;
  late Future<int> _totalCourseCredits;
  late Future<String?> _email;
  late Future<String?> _name;
  late Future<String?> _gpaMethod;
  late Future<double> _currentGPA;
  late String name;
  late String email;
  late String gpaMethod;
  late int totalCourseCredits;
  late int totalSemesters;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userTotalSemesterController = TextEditingController();
  final TextEditingController userTotalCreditController = TextEditingController();

  @override
  void clear() {
    userNameController.clear();
    userEmailController.clear();
    userTotalCreditController.clear();
    userTotalSemesterController.clear();

    // Collect all controllers to be cleared
    List<TextEditingController> controllersToClear = _newGradeControllers.values.toList();

    // Clear the map after collecting all controllers
    _newGradeControllers.clear();

    // Clear each controller
    for (TextEditingController controller in controllersToClear) {
      controller.clear();
    }
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
    _gpaMethod = _dbHelper.getGPAMethod();
    _dbHelper.retrieveDefaultGradeWeights().then((value) {
      setState(() {
        _courseWeightMap = value;
      });
      _newCourseWeightMap=_courseWeightMap!;
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
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      endDrawer: _buildDrawer(),
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
      String? nameFromFuture= await _dbHelper.getName();
      int? totalCourseCreditsFromFuture= await _dbHelper.getTotalCourseCredits();
      int? totalSemestersFromFuture= await _dbHelper.getTotalSemesters();
      String? gpaMethodFromFuture = await _dbHelper.getGPAMethod();
      // Assign the value to a non-nullable String variable
      name = nameFromFuture ?? '';
      email = emailFromFuture ?? '';
      gpaMethod = gpaMethodFromFuture ?? '';
      totalSemesters = totalSemestersFromFuture ?? 0;
      totalCourseCredits = totalCourseCreditsFromFuture ?? 0;
      _dbHelper.retrieveDefaultGradeWeights().then((value) {
        setState(() {
          _courseWeightMap = value;
        });
        _newCourseWeightMap=_courseWeightMap!;
      }).catchError((error) {
        print('Error retrieving default grade weights: $error');
        setState(() {
          _courseWeightMap = {};
        });
      });
      _newGradeControllers = {
        for (var entry in _courseWeightMap!.entries)
          entry.key: TextEditingController(text: entry.value.toString()),
      };
      _newCourseWeightMap = {
        for (var entry in _courseWeightMap!.entries)
          entry.key: entry.value,
      };

      print('Email: $email');
    } catch (error) {
      print('Error fetching email: $error');
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
          onTap: () {
            _scaffoldKey.currentState?.openEndDrawer();
          },
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
              icon: SvgPicture.asset(
                'assets/icons/trnmenu.svg',
                height: 18,
                width: 18,
              ),
              iconSize: 20,
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ),
        ),
      ],
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(

        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.zero,

            child: Stack(
              children: [
                SvgPicture.asset(
                  "assets/images/card.svg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(16.0),
                  child: const Text(
                    'MyGPA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home',
              style: TextStyle(
                color: Color(0xff2b2b2b),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),

            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('About App',
              style: TextStyle(
                color: Color(0xff2b2b2b),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutApp()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BuyMeACoffeeButton(), // Add the button here
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage() {
    return Column(
      children: <Widget>[
        SvgPicture.asset(
          //'assets/images/settings.gif',
          'assets/images/settings.svg',
          height: 250,
          width: 250,
          key: UniqueKey(),
        ),
        // GifView.asset(
        //   'assets/images/settings.gif',
        //   height: 250,
        //   width: 250,
        //   key: UniqueKey(),
        // ),
        //Lottie.asset('assets/animation/loadanimation.json',height: 150,width: 150),
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
                    showChangeGradeMethod = false;
                  });
                },
              ),
              if (showProfileContainer)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: _buildProfileContainer(),
                ),
              ListTile(
                title: const Text(
                  'Choose Grading Method',
                  style: TextStyle(
                    color: Color(0xff2b2b2b),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    showChangeGradeMethod = !showChangeGradeMethod;
                    showProfileContainer = false;
                    showGradingMethodContainer = false;
                  });
                },
              ),
              if (showChangeGradeMethod)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: _buildChangeGradeMethod(),
                ),
              ListTile(
                title: const Text(
                  'Update Custom Grading Method',
                  style: TextStyle(
                    color: Color(0xff2b2b2b),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    showGradingMethodContainer = !showGradingMethodContainer;
                    showProfileContainer = false;
                    showChangeGradeMethod = false;
                  });
                },
              ),
              if (showGradingMethodContainer)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: _buildGradingMethodContainer(),
                ),
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
          _buildNumberField('Total Semesters', 'Enter Total Semesters', userTotalSemesterController),
          const SizedBox(height: 15),
          _buildNumberField('Total Credits', 'Enter Total Credits', userTotalCreditController),
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
              await _confirmUpdateProfileDialog(context);
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

  Widget _buildChangeGradeMethod() {

     var buttonVal = (gpaMethod == 'default')
        ? "Change to Custom"
        : (gpaMethod == 'custom')
        ? "Change to Default"
        : "Default Text"; // Fallback value

     var currentMethod = (gpaMethod == 'default')
         ? "Default"
         : (gpaMethod == 'custom')
         ? "Custom"
         : "Default Text"; // Fallback value

     var gMethod = (gpaMethod == 'default')
     ? "default"
     : (gpaMethod == 'custom')
     ? "custom"
     : "Default Text";


    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xff2b2b2b), width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Current GPA method: ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff2b2b2b),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                currentMethod,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff2b2b2b),
                ),
              ),
            ],
          ),
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
              print('Gpa method is $gMethod');
              await _confirmChangeGradeWeightsDialog(context,gMethod);
            },
            child: Text(
              buttonVal,
              style: const TextStyle(
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

  Future<void> _confirmChangeGradeWeightsDialog(BuildContext context,String gMethod) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Change Grading Method'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to change your Grading method?',
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
                gradeMethodChanged=true;
                customchanged=false;
                String gMethodChanged='';
                if(gMethod=='default'){
                  gMethodChanged="custom";
                }else if(gMethod=='custom'){
                  gMethodChanged='default';
                }else{
                  print("Error in A");
                }
                gpaMethod = gMethodChanged;
                await _updateUserDetails();
                showGradingMethodContainer = false;
                showChangeGradeMethod = false;

                setState(() {
                  gradeMethodChanged=false;
                  asignDetails();
                });

                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DoneSettingsPage(),
                  ),
                );
              },
              child: const Text(
                'Change',
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

  Future<void> _updateUserDetails() async {
    int userId = 1;
    List<User> users = await _dbHelper.getUsers();
    User? existingUser;
    try {
      existingUser = users.firstWhere((user) => user.id == userId);
      print(existingUser.name);
    } catch (e) {
      existingUser = null;
    }
    if (existingUser != null) {
      String gpaMethodValue= gpaMethod;
      if(gpaMethodValue=="custom"){
        double? gpaFromFuture =await _calculateNewGpa(_newCourseWeightMap,"custom");
        double? newCurrentGpa = gpaFromFuture ?? 0.0;
      }else if(gpaMethodValue=="default"){
        double? gpaFromFuture =await _calculateNewGpa(existingUser.defaultGradeWeights,"default");
        double? newCurrentGpa = gpaFromFuture ?? 0.0;
      }
      gpaMethodValue='';
      // double? gpaFromFuture =await _calculateNewGpa();
      // double? newCurrentGpa = gpaFromFuture ?? 0.0;

      if(customchanged==false && gradeMethodChanged==false){
        String newName = userNameController.text.trim();
        String newEmail = userEmailController.text.trim();
        int newTotalCourseCredits = int.parse(userTotalCreditController.text.trim());
        int newTotalSemesters = int.parse(userTotalSemesterController.text.trim());
        User updatedUser = User(
          id: existingUser.id,
          name: newName,
          email: newEmail,
          //currentGPA: newCurrentGpa,
          currentGPA: existingUser.currentGPA,
          totalSemesters: newTotalSemesters,
          gpaMethod: gpaMethod,
          totalCourseCredits: newTotalCourseCredits,
          customGradeWeights: existingUser.customGradeWeights,
          defaultGradeWeights: existingUser.defaultGradeWeights,
        );
        print('gpa method when saving is 1 $gpaMethod');


        await _dbHelper.updateUser(updatedUser);
        clear();
        setState(() {
          asignDetails();
        });
        if (_scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Details updated!',textAlign: TextAlign.center,)),
          );
        }
        print("User updated successfully userdetails");
      }else if(customchanged==true && gradeMethodChanged==false){
        User updatedUser = User(
          id: existingUser.id,
          name: existingUser.name,
          email: existingUser.email,
          //currentGPA: newCurrentGpa,
          currentGPA: existingUser.currentGPA,
          totalSemesters: existingUser.totalSemesters,
          gpaMethod: gpaMethod,
          totalCourseCredits: existingUser.totalCourseCredits,
          customGradeWeights: _newCourseWeightMap,
          defaultGradeWeights: existingUser.defaultGradeWeights,
        );
        print('gpa method when saving is 2 $gpaMethod');
        await _dbHelper.updateUser(updatedUser);
        clear();
        setState(() {
          asignDetails();
        });
        if (_scaffoldKey.currentContext != null) {
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
            const SnackBar(content: Text('Details updated!',textAlign: TextAlign.center,)),
          );
        }
        print("Custom grading method added and applied");
    } else if(gradeMethodChanged==true && customchanged==false) {
      User updatedUser = User(
        id: existingUser.id,
        name: existingUser.name,
        email: existingUser.email,
        //currentGPA: newCurrentGpa,
        currentGPA: existingUser.currentGPA,
        totalSemesters: existingUser.totalSemesters,
        gpaMethod: gpaMethod,
        totalCourseCredits: existingUser.totalCourseCredits,
        customGradeWeights: existingUser.customGradeWeights,
        defaultGradeWeights: existingUser.defaultGradeWeights,
      );
      print('gpa method when saving is 3 $gpaMethod');
      await _dbHelper.updateUser(updatedUser);
      clear();
      setState(() {
        asignDetails();
      });
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Details updated!',textAlign: TextAlign.center,)),
        );
      }
      print("Grading method changed to $gpaMethod");
    }else{
      if (_scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('User not found',textAlign: TextAlign.center,)),
        );
      }
    }
  }
  }

  Future<double> _calculateNewGpa(Map<String,dynamic> courseWeightMap,String gpaMethod) async {

    double sumOfMultiplyOfWeightCredit = 0.0;
    List<Course> coursesList = await _dbHelper.getCourses();

    int sumOfCurrentTotalCredits = await _dbHelper.getCurrentTotalCourseCredits();
    if(gpaMethod=="default"){
      for (Course course in coursesList){
        var item;
        for(MapEntry<String,dynamic> item in courseWeightMap.entries){
          //print('Key: ${item.key}, Value: ${item.value}');
          if(item.key==course.grade){
            print('Key: ${item.key}, Value: ${item.value}');
            double multiplyOfWeightCredit =item.value  * course.credit;
            sumOfMultiplyOfWeightCredit+=multiplyOfWeightCredit;
          }
        }
      }
    }
    if(gpaMethod=="custom"){
      for (Course course in coursesList){
        var item;
        for(MapEntry<String,dynamic> item in _courseWeightMap!.entries){
          //print('Key: ${item.key}, Value: ${item.value}');
          if(item.key==course.grade){
            print('Key: ${item.key}, Value: ${item.value}');
            double multiplyOfWeightCredit =item.value  * course.credit;
            sumOfMultiplyOfWeightCredit+=multiplyOfWeightCredit;
          }
        }
      }
    }
    print('sum of multiply $sumOfMultiplyOfWeightCredit and sum of total credits $sumOfCurrentTotalCredits');
    double newCurrentGpa = sumOfCurrentTotalCredits > 0
        ? sumOfMultiplyOfWeightCredit / sumOfCurrentTotalCredits
        : 0.0;
    print("new GPA is $newCurrentGpa");
    return newCurrentGpa;
  }


  Future<void> _done(BuildContext context) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // Schedule the dialog to close after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          title: const Text(
            'All Done!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xff2b2b2b),
            ),
          ),
          content: SingleChildScrollView(
            child: Image.asset(
              'assets/images/settings.gif',
              height: 250,
              width: 250,
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmUpdateProfileDialog(BuildContext context) async {
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
                customchanged=false;
                gradeMethodChanged=false;
                showProfileContainer=false;
                await _updateUserDetails();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DoneSettingsPage(),
                  ),
                );
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
              //_displayNewCourseWeight();
              await _confirmUpdateGradeWeightsDialog(context);
            },
            child: const Text(
              'Update Grade Method',
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

  Future<void> _confirmUpdateGradeWeightsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Prevent dialog from closing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Update Custom Grading Method'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to update your Grade weights?',
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
                setState(() {
                  gpaMethod = "custom";
                  customchanged = true;
                  gradeMethodChanged=false;
                  showGradingMethodContainer = false; // Adjust this based on what you want to display
                  showChangeGradeMethod = false; // Reset other flags if needed
                });
                await _updateUserDetails();
                setState(() {
                  customchanged = false;
                  asignDetails();
                });

                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DoneSettingsPage(),
                  ),
                );
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

  Column _buildTextFieldGrade(String label, String hint, String gradeVal) {
    // Ensure controller is initialized
    if (!_newGradeControllers.containsKey(label)) {
      _newGradeControllers[label] = TextEditingController(text: gradeVal);
    }
    TextEditingController gradeValueController = _newGradeControllers[label]!;

    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        TextField(
          keyboardType: TextInputType.number,
          cursorColor: const Color(0xff2b2b2b),
          controller: gradeValueController,
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
          onChanged: (text) {
            double newValue;
            try {
              newValue = double.parse(text);
            } catch (e) {
              newValue = 0;
            }
            _changeTextField(label, newValue);
          },
        ),
      ],
    );
  }

  void _changeTextField(String label, double newValue) {
    setState(() {
      _newCourseWeightMap[label] = newValue;
      print(newValue.toString());
      print("The value changed to :${_newCourseWeightMap[label]}");
    });
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

  TextField _buildNumberField(String label, String hint, TextEditingController controller) {
    return TextField(
      keyboardType: TextInputType.number,
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

