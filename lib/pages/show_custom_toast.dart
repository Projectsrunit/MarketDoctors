import 'dart:ui';
import 'package:flutter/material.dart';

List<GlobalKey> _toastKeys = []; // Track the keys of displayed toasts
List<String> _shownMessages = []; // Track the messages of displayed toasts

Future<void> showCustomToast(BuildContext context, String message, [String? redOn]) async {
  // Check if the message has already been shown
  if (_shownMessages.contains(message)) return;

  // Add the message to the list to prevent re-showing
  _shownMessages.add(message);

  GlobalKey key = GlobalKey(); // Create a unique key for the toast
  _toastKeys.add(key);

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: SizedBox(
          width: 200,
          height: 50,
          child: AlertDialog(
            backgroundColor: redOn != null ? Colors.red : Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    },
  );

  Future.delayed(Duration(seconds: 2), () {
    // Remove the toast from the list after it's done showing
    _toastKeys.remove(key);
    _shownMessages.remove(message);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  });
}
