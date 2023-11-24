import 'package:flutter/material.dart';

extension SnackbarMessage on BuildContext {
  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        margin: const EdgeInsets.all(8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
