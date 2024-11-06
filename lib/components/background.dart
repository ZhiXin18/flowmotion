import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Set the full background image using Positioned.fill
          Positioned.fill(
            child: Image.asset(
              "images/main1.jpg",
              fit: BoxFit.cover, // Ensures the image covers the entire background
            ),
          ),
          child
        ],
      ),
    );
  }
}