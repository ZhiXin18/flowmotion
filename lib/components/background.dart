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
          /*Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "images/top1.png",
              width: size.width
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "images/top2.png",
              width: size.width
            ),
          ),*/
          // Set the full background image using Positioned.fill
          Positioned.fill(
            child: Image.asset(
              "images/main1.jpg",
              fit: BoxFit.cover, // Ensures the image covers the entire background
            ),
          ),
          /*Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "images/bottom1.png",
              width: size.width
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "images/bottom2.png",
              width: size.width
            ),
          ),*/
          child
        ],
      ),
    );
  }
}