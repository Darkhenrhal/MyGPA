import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mygpa/user.dart';
import 'package:mygpa/course.dart';
import 'package:mygpa/databasehelper.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<double> _completionPercentage;
  late Future<double> _currentGPA;
  late Future<int> _totalCurrentCourseCredits;
  late Future<int> _totalCourseCredits;
  Map<String, dynamic>? _courseWeightMap;
  int _selectedIndex = -1;
  bool showAddCourseCard = false;
  bool showViewCoursesCard = false;
  final TextEditingController courseTitleController = TextEditingController();
  final TextEditingController courseGradeController = TextEditingController();
  final TextEditingController courseCreditController = TextEditingController();
  final TextEditingController courseSemesterController = TextEditingController();
  String? selectedGrade;
  @override
  void initState() {
    super.initState();
    _currentGPA = _dbHelper.getCurrentGPA();
    _totalCurrentCourseCredits = _dbHelper.getCurrentTotalCourseCredits();
    _totalCourseCredits = _dbHelper.getTotalCourseCredits();
    _completionPercentage = _calculateCompletionPercentage();
    // Assign the result of retrieveDefaultGradeWeights directly to _courseWeightMap
    _dbHelper.retrieveDefaultGradeWeights().then((value) {
      setState(() {
        _courseWeightMap = value; // Directly use value here
      });
    }).catchError((error) {
      print('Error retrieving default grade weights: $error');
      setState(() {
        _courseWeightMap = {}; // Handle error state as needed
      });
    });

  }

  Future<double> _calculateCompletionPercentage() async {
    final totalCurrentCourseCredits = await _totalCurrentCourseCredits;
    final totalCourseCredits = await _totalCourseCredits;

    if (totalCourseCredits > 0) {
      print(totalCurrentCourseCredits.toString());
      return (totalCurrentCourseCredits / totalCourseCredits) * 100;
    } else {
      print(totalCurrentCourseCredits.toString());
      return 0.0;
    }
  }

  Future<double> _getWeight(String courseGrade) async {
    if (_courseWeightMap == null) {
      print('Weights map is null or not yet fetched');
      return 0.0;
    }

    dynamic correspondingWeight = _courseWeightMap![courseGrade];
    if (correspondingWeight != null) {
      print('Corresponding value for $courseGrade: $correspondingWeight');
      return correspondingWeight as double;
    } else {
      print('No corresponding value found for $courseGrade');
      return 0.0;
    }
  }


  Future<void> _addCourse() async {
    String courseTitle = courseTitleController.text.trim();
    String? courseGrade = selectedGrade;
    int courseCredit = int.tryParse(courseCreditController.text.trim()) ?? 0;
    int courseSemester = int.tryParse(courseSemesterController.text.trim()) ?? 0;

    if (courseGrade == null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Please select a grade.')),
      );
      return;
    }

    double courseWeight = await _getWeight(courseGrade!);

    // Validate input
    if (courseTitle.isEmpty || courseGrade.isEmpty || courseCredit <= 0 || courseSemester <= 0) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
      return;
    }

    // Create Course object
    Course newCourse = Course(
      title: courseTitle,
      grade: courseGrade,
      credit: courseCredit,
      semester: courseSemester,
      weight: courseWeight,
    );

    try {
      int result = await _dbHelper.insertCourse(newCourse);
      if (result != 0) {
        setState(() {
          showAddCourseCard = false;
          showViewCoursesCard = true;
          _currentGPA = _dbHelper.getCurrentGPA();
          _totalCurrentCourseCredits = _dbHelper.getCurrentTotalCourseCredits();
          _completionPercentage = _calculateCompletionPercentage();
        });
        _updateUserDetails();

        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Course added successfully.')),
        );
        // Clear text fields after adding the course
        courseSemesterController.clear();
        courseCreditController.clear();
        courseTitleController.clear();
        setState(() {
          selectedGrade = null; // Reset the selected grade
        });
      } else {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(content: Text('Failed to add course. Please try again.')),
        );
      }
    } catch (exception) {
      print('Error inserting course: $exception');
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again later.')),
      );
    }

  }

  Future<void> _updateUserDetails() async {
    int userId = 1;
    List<User> users = await _dbHelper.getUsers();

    User? existingUser;
    try {
      existingUser = users.firstWhere((user) => user.id == userId);
    } catch (e) {
      existingUser = null;
    }

    if (existingUser != null) {
      double sumOfMultiplyOfWeightCredit = await _dbHelper.calculateSumOfMultiplyOfWeightCredit();
      int sumOfCurrentTotalCredits = await _dbHelper.getCurrentTotalCourseCredits();

      double newCurrentGpa = sumOfCurrentTotalCredits > 0
          ? sumOfMultiplyOfWeightCredit / sumOfCurrentTotalCredits
          : 0.0;

      User updatedUser = User(
        id: existingUser.id,
        name: existingUser.name,
        email: existingUser.email,
        currentGPA: newCurrentGpa,
        totalSemesters: existingUser.totalSemesters,
        gpaMethod: existingUser.gpaMethod,
        totalCourseCredits: existingUser.totalCourseCredits,
        customGradeWeights: existingUser.customGradeWeights,
        defaultGradeWeights: existingUser.defaultGradeWeights,
      );

      await _dbHelper.updateUser(updatedUser);

      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('User details updated successfully')),
      );
      print("user updated successfully ${newCurrentGpa}}");
    } else {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Ensure _scaffoldKey is assigned here
      appBar: _buildAppBar(),
      endDrawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildHomePage(),
              Center(
                child: _buildHomeButtons(context),
              ),
              if (showAddCourseCard)
                _buildAddCourse(
                    courseSemesterController,
                    courseCreditController,
                    courseTitleController,
                    courseGradeController,
                    selectedGrade,
                      (newValue) {
                    setState(() {
                      selectedGrade = newValue;
                    });
                  },),
              if (showViewCoursesCard) _buildCourseList(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHomeButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
        children: <Widget>[
          _buildButton('Add Course', 0, () {
            setState(() {
              showAddCourseCard = true;
              showViewCoursesCard = false;
            });
          }),
          _buildButton('View Courses', 1, () {
            setState(() {
              showAddCourseCard = false;
              showViewCoursesCard = true;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildButton(String text, int index, VoidCallback onPressed) {
    bool isSelected = _selectedIndex == index;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
          onPressed(); // Call the provided onPressed callback
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.pressed)) {
            return const Color(0xff34312D); // Color when pressed
          }
          return isSelected ? const Color(0xff34312D) : Colors
              .white; // Selected and default colors
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          return isSelected ? Colors.white : const Color(
              0xff2b2b2b); // Text color based on selection
        }),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 25, vertical: 7),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(
              color: Color(0xff2b2b2b), width: 3,), // Black border
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    );
  }


  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 500.0, // specify the width
            height: 200.0, // specify the height
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SvgPicture.asset(
                    "assets/images/card.svg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff2b2b2b).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Positioned(
                  left: 20.0,
                  top: 20.0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Your current GPA,',
                      style: TextStyle(
                        color: Color(0xffCBCBCB),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: FutureBuilder<double>(
                      future: _currentGPA,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text(
                            'Error',
                            style: TextStyle(
                              color: Color(0xffE1E1E1),
                              fontSize: 60,
                            ),
                          );
                        } else {
                          return Text(
                            snapshot.data!.toStringAsFixed(2),
                            style: const TextStyle(
                              color: Color(0xffE1E1E1),
                              fontSize: 60,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 20.0,
                  top: 135.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          const Text(
                            'Completed Credits :',
                            style: TextStyle(
                              color: Color(0xffCBCBCB),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          FutureBuilder<int>(
                            future: _totalCurrentCourseCredits,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                  'Loading...',
                                  style: TextStyle(
                                    color: Color(0xffCBCBCB),
                                    fontSize: 15,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Text(
                                  'Error',
                                  style: TextStyle(
                                    color: Color(0xffCBCBCB),
                                    fontSize: 15,
                                  ),
                                );
                              } else {
                                return Text(
                                  snapshot.data!.toString(),
                                  style: const TextStyle(
                                    color: Color(0xffCBCBCB),
                                    fontSize: 15,
                                  ),
                                );
                              }
                            },),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Add some space between the texts
                      Row(
                        children: <Widget>[
                          const Text(
                            'Completion Percentage :',
                            style: TextStyle(
                              color: Color(0xffCBCBCB),
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          FutureBuilder<double>(
                            future: _completionPercentage,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text(
                                  'Loading...',
                                  style: TextStyle(
                                    color: Color(0xffCBCBCB),
                                    fontSize: 15,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Text(
                                  'Error',
                                  style: TextStyle(
                                    color: Color(0xffCBCBCB),
                                    fontSize: 15,
                                  ),
                                );
                              } else {
                                // Fixed: Check for null and handle default case
                                final percentage = snapshot.data ?? 0.0;
                                return Text(
                                  percentage.toStringAsFixed(2) + '%',
                                  style: const TextStyle(
                                    color: Color(0xffCBCBCB),
                                    fontSize: 15,
                                  ),
                                );
                              }
                            },)
                        ],
                      )

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Summary',
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


  Widget _buildAddCourse(
      TextEditingController courseSemesterController,
      TextEditingController courseCreditController,
      TextEditingController courseTitleController,
      TextEditingController courseGradeController,
      String? selectedGrade,
      ValueChanged<String?> onGradeChanged,) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xff2b2b2b),width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Center(
            child: Text(
              'Add Course',
              style: TextStyle(
                color: Color(0xff2b2b2b),
                fontSize: 22,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          const SizedBox(height: 15),
          _buildTextField(
            'Course Title',
            'Enter Course Title',
            courseTitleController,
          ),
          const SizedBox(height: 15),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildTextField(
                  'Course Credit',
                  'Enter Credit',
                  courseCreditController,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildTextField(
                  'Course Semester',
                  'Enter Semester',
                  courseSemesterController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildDropDownMenu(
            label: 'Grade',
            hint: 'Select Grade',
            items: ['A+','A','A-','B+','B','B-','C+','C','C-','D+','D','E','F'],
            selectedItem: selectedGrade,
            onChanged: onGradeChanged,
          ),
          const SizedBox(height: 15),

          ElevatedButton(

            onPressed: () => {
              _addCourse(),
            },// Ensure _addCourse() is called directly
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
              'Add',
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
            title: const Text('Settings',
              style: TextStyle(
                color: Color(0xff2b2b2b),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),

            ),
            onTap: () {
              // Handle item 1 tap
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
              // Handle item 2 tap
            },
          ),
        ],
      ),
    );
  }


  Widget _buildCourseList() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          const Text(
            'Your Courses',
            style: TextStyle(
              color: Color(0xff2b2b2b),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Semester',
              style: TextStyle(
                color: Color(0xff2b2b2b),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          _buildCourseCard(),
        ],
      ),
    );
  }

  Widget _buildCourseCard() {
    return Container(
      width: 500,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff2b2b2b)),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Title',
                      style: TextStyle(
                        color: Color(0xff2b2b2b),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Credits',
                      style: TextStyle(
                        color: Color(0xff2b2b2b),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Grade',
                      style: TextStyle(
                        color: Color(0xff2b2b2b),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Adjust spacing between text and icons
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/update.svg',
                      height: 20,
                      width: 20,
                    ),
                    iconSize: 20,
                    color: Colors.red,
                    onPressed: () {
                      // Handle onPressed event here
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/icons/delete.svg',
                      height: 20,
                      width: 20,
                    ),
                    iconSize: 20,
                    color: Colors.red,
                    onPressed: () {
                      // Handle onPressed event here
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropDownMenu({
    required String label,
    required String hint,
    required List<String> items,
    required String? selectedItem,
    required ValueChanged<String?> onChanged,
  }){
    return DropdownButtonFormField<String>(

      value: selectedItem,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        fillColor: const Color(0xffE1E1E1),
        hintText: hint,
        labelStyle: _labelTextStyle,
        floatingLabelStyle: _floatingLabelStyle,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Color(0xff2b2b2b)),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  TextField _buildTextField(String label, String hint,
      TextEditingController controllerName) {
    return TextField(
      cursorColor: const Color(0xff2b2b2b),
      controller: controllerName,
      decoration: InputDecoration(
        labelText: label,
        fillColor: const Color(0xffE1E1E1),
        hintText: hint,
        labelStyle: _labelTextStyle,
        floatingLabelStyle: _floatingLabelStyle,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(10.0)), // Set border radius here
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          // Set border radius here
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
