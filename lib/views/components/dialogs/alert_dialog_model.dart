import 'package:flutter/material.dart';

// Resuable Generic Dialog with a title, message, and buttons
@immutable
class AlertDialogModel<T> {
  final String title;
  final String message;
  final Map<String, T> buttons;
  // final Color? color;

  const AlertDialogModel({
    required this.title,
    required this.message,
    required this.buttons,
    // this.color,
  });
}

extension Present<T> on AlertDialogModel<T> {
  Future<T?> present(BuildContext context) {
    return showDialog<T?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          // convert the map of buttons to a list of buttons
          actions: buttons.entries.map(
            // entry is a MapEntry<String, T>
            (entry) {
              return TextButton(
                child: Text(
                  // style: TextStyle(color: color),
                  entry.key,
                ),
                onPressed: () {
                  // pop the dialog with the value of the button
                  Navigator.of(context).pop(
                    entry.value,
                  );
                },
              );
            },
          ).toList(),
        );
      },
    );
  }
}
