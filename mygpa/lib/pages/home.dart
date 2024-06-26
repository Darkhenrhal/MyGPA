import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildBody(),
          buildButtons(),
        ],
      )
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Column(
        children: <Widget>[
          buildCard(),
        ],
      ),
    );
  }


AppBar buildAppBar() {
  return AppBar(
    title: const Text(
      'EasyGPA',
      style: TextStyle(
        color: Colors.black,
        fontSize: 23,
        fontWeight: FontWeight.w600,
      ),
    ),
    backgroundColor: const Color(0xffEFF0F1),
    centerTitle: true,
    elevation: 0, // to make no shadow
    // LEFT BUTTON
    leading: GestureDetector(
      onTap: () {
        // Your code here
      },
      child: Container(
        width: 30, // Adjusted width for consistency
        height: 30, // Adjusted height for consistency
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xffD8D9D9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          'assets/icons/back.svg',
          height: 15, // Adjusted height of the SVG icon
          width: 15, // Adjusted width of the SVG icon
        ),
      ),
    ),
    // RIGHT BUTTON
    actions: [
      GestureDetector(
        onTap: () {
          // Your code here
        },
        child: Container(
          width: 35, // Adjusted width for consistency
          height: 35, // Adjusted height for consistency
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xffD8D9D9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/menu.svg',
            height: 16, // Adjusted height of the SVG icon
            width: 16, // Adjusted width of the SVG icon
          ),
        ),
      ),
    ],
  );
}


  Card buildCard() {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 4,
      color: const Color(0xffEFF0F1),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(

              title: Text(
                'Summary',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'GPA',
                    style:
                      TextStyle(fontSize: 18),

                  ),
                  Text(
                    'Completed Credits',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Completed Courses',
                    style: TextStyle(fontSize: 18),
                  ),

                ],
              ),
            ),
          ],

        ),
      ),
    );
  }

  Container buildButtons() {
    return Container(
      padding: const EdgeInsets.all(10), // Optional: Add some padding
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Your code here
                },
                child: const Text('Button 1'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Your code here
                },
                child: const Text('Button 2',style: TextStyle(fontSize: 15)),

              ),
            ],
          ),
          const SizedBox(height: 10), // Optional: Add some space between rows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  // Your code here
                },
                child: const Text('Button 3'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Your code here
                },
                child: const Text('Button 4'),
              ),
            ],
          ),
        ],
      ),
    );
  }





}

