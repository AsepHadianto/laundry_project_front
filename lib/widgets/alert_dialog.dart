import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  CustomAlertDialog({
    required this.message,
    required this.confirmText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: Text(confirmText),
        ),
      ],
    );
  }
}

void showCustomAlertDialog({
  required BuildContext context,
  required String message,
  required String confirmText,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        message: message,
        confirmText: confirmText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      );
    },
  );
}
