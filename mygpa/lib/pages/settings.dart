
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool showProfileContainer = false;
  bool showGradingMethodContainer = false;

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
          margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    color: Color(0xff2b2b2b),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  setState(() {
                    showProfileContainer = !showProfileContainer;
                    showGradingMethodContainer = false; // Hide grading method container
                  });
                },
              ),
              if (showProfileContainer) ...[
                _buildProfileContainer(),
              ],
              ListTile(
                title: const Text(
                  'Grading Method',
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
                _buildGradingMethodContainer(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          _buildTextField('Name', 'Enter Name'),
          const SizedBox(height: 15,),
          _buildTextField('Email', 'Enter Email'),
          const SizedBox(height: 15,),
          _buildTextField('Total Semesters', 'Enter Total Semesters'),
          const SizedBox(height: 15,),
          _buildTextField('Total Credits', 'Enter Total Credits'),
        ],
      ),
    );
  }

  Widget _buildGradingMethodContainer() {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          for (int i = 1; i <= 10; i++)
            _buildTextField('A+ $i', 'Weight for A+ $i'),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}

