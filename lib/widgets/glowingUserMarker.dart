import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class GlowingUserMarker extends StatelessWidget {

  const GlowingUserMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AvatarGlow(
          glowColor: Colors.blue,
          child: Material(
            elevation: 8.0,
            shape: const CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Image.asset(
                'images/avatar.png',
                height: 50,
              ),
              radius: 30.0,
            ),
          ),
        ),
      ],
    );
  }
}