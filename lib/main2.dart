import 'package:flutter/material.dart';
import 'package:laundry_project/widgets/alert_dialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reusable Alert Dialog Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => showCustomAlertDialog(
            context: context,
            message: 'Are you sure you want to proceed?',
            confirmText: 'Proceed',
            onConfirm: () {
              // Perform the confirm action
              Navigator.of(context).pop();
            },
            onCancel: () {
              // Perform the cancel action
              Navigator.of(context).pop();
            },
          ),
          child: Text('Show Alert Dialog'),
        ),
      ),
    );
  }
}
