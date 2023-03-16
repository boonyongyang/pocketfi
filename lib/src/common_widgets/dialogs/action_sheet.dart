// Cupertino Action Sheet example

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionSheet extends StatelessWidget {
  const ActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cupertino Action Sheet'),
      ),
      body: Center(
        child: CupertinoButton(
          child: const Text('Show Cupertino Action Sheet'),
          onPressed: () {
            showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                title: const Text('Cupertino Action Sheet'),
                message: const Text('Select an option'),
                actions: <Widget>[
                  CupertinoActionSheetAction(
                    child: const Text('Option 1'),
                    onPressed: () {
                      Navigator.pop(context, 'Option 1');
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Option 2'),
                    onPressed: () {
                      Navigator.pop(context, 'Option 2');
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('Option 3'),
                    onPressed: () {
                      Navigator.pop(context, 'Option 3');
                    },
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: const Text('Cancel'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
