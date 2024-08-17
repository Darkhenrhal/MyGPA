import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: buildAboutAppPage(context),
          ),
        ),
      ),
      backgroundColor: const Color(0xfffcffff),
    );
  }


  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'MyGPA',
        style: TextStyle(
          color: Color(0xff332e31),
          fontSize: 30,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
      backgroundColor: const Color(0xffecebf2),
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
              color: const Color(0xffecebf2),
              borderRadius: BorderRadius.circular(10),
            ),

          ),
        ),
      ],
    );
  }

  Container buildAboutAppPage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),

      child: Column(
        children: <Widget>[
          const Text(
            'Welcome to MyGPA, ',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xff693ae0),
              fontSize: 25,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 15,),
          const Text(
                'This is your ultimate academic companion designed to help you keep track '
                'of your academic performance effortlessly. Whether you\'re a high '
                'school student, college undergraduate, or postgraduate student, '
                'this app provides a simple and intuitive way to calculate your '
                'Grade Point Average (GPA) and manage your courses and grades efficiently.'
                    ,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff2b2b2b),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 15,),


          const Text(
            'Keep working, Don\'t give up, \n'
                'You can Win !!!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff693ae0),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 20), // Add some spacing before the SVG
          SvgPicture.asset(
            'assets/images/about.svg',
            height: 300,
            width: 300,
          ),
          const SizedBox(height: 15,),
          const Text(
            'Powered By,',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xff8970ce),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const Text(
                'Darkhenrhal',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xff693ae0),
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),

        ],
      ),
    );
  }
}