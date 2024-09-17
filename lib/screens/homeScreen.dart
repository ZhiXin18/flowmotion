import 'package:flutter/material.dart';

import '../widgets/navigationBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 0),
    );
  }
}

