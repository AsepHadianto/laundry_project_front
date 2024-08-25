import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final double height;

  CustomAppBar({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
      ),
    );
  }
}
