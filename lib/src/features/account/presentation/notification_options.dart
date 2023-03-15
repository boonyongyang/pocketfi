import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocketfi/src/constants/app_colors.dart';

class SwitchOption extends StatefulWidget {
  final String title;
  final bool isActive;

  const SwitchOption({required this.title, required this.isActive, Key? key})
      : super(key: key);

  @override
  SwitchOptionState createState() => SwitchOptionState();
}

class SwitchOptionState extends State<SwitchOption> {
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return buildNotificationOptionRow(widget.title, isActive);
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            value: isActive,
            activeColor: AppColors.mainColor2,
            onChanged: (bool val) {
              setState(() {
                isActive = val;
              });
            },
          ),
        )
      ],
    );
  }
}
