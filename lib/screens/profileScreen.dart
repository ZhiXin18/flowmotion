import 'package:flutter/material.dart';

import '../widgets/navigationBar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: MyBottomNavigationBar(selectedIndexNavBar: 1),
    );
  }
}

