import 'package:flutter/material.dart';
//import '../utilities/firebase_calls.dart';

class MyBottomNavigationBar extends StatefulWidget {
  MyBottomNavigationBar({Key? key, required this.selectedIndexNavBar})
      : super(key: key);
  int selectedIndexNavBar;

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  void _onTap(int index) {
    widget.selectedIndexNavBar = index;
    setState(() {
      switch (index) {
        case 0:
         // if (newUser == true) {
            Navigator.pushReplacementNamed(context, '/home');
         // } else {
           // Navigator.pushReplacementNamed(context, '/home');
          //}
          break;
        case 1:
          //if (newUser == true) {
            Navigator.pushReplacementNamed(context, '/profile');
         // } else {
           // Navigator.pushReplacementNamed(context, '/exercise');
         // }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black38,
      items: const [
        BottomNavigationBarItem(
          label: 'Dashboard',
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.person),
        ),
      ],
      currentIndex: widget.selectedIndexNavBar,
      onTap: _onTap,
    );
  }
}
