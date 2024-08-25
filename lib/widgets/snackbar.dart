import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  CustomSnackBar({required this.message, this.backgroundColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

void showCustomSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 8.0,
      left: 16.0,
      right: 16.0,
      child: Material(
        color: Colors.transparent,
        child: CustomSnackBar(message: message),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(Duration(seconds: 5), () {
    overlayEntry.remove();
  });
}
