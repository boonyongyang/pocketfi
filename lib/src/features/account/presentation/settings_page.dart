import 'package:flutter/material.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/account/presentation/notification_options.dart';

@immutable
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 71, 86, 71),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            Row(
              children: const [
                Icon(
                  Icons.person,
                  color: AppColors.mainColor1,
                ),
                SizedBox(width: 8),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(height: 10),
            // buildAccountOptionRow(context, "Social"),
            buildAccountOptionRow(context, "Language"),
            buildAccountOptionRow(context, "Privacy and security"),
            const SwitchOption(
              title: "App lock",
              isActive: false,
            ),
            const SizedBox(height: 40),
            Row(
              children: const [
                Icon(
                  Icons.volume_up_outlined,
                  color: AppColors.mainColor1,
                ),
                SizedBox(width: 8),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(height: 10),
            // buildNotificationOptionRow("Transaction activity", true),
            // buildNotificationOptionRow("Budget progress", true),
            // buildNotificationOptionRow("Bill Reminders", false),
            // buildNotificationOptionRow("Debt Reminders", true),
            // buildNotificationOptionRow("Savings Reminders", false),
            const SwitchOption(
              title: "Transaction activity",
              isActive: true,
            ),
            const SwitchOption(
              title: "Budget progress",
              isActive: true,
            ),
            const SwitchOption(
              title: "Bill Reminders",
              isActive: false,
            ),
            const SwitchOption(
              title: "Debt Reminders",
              isActive: true,
            ),
            const SwitchOption(
              title: "Savings Reminders",
              isActive: false,
            ),
            const SizedBox(height: 50),
            // Center(
            //   child: OutlinedButton(
            //     style: OutlinedButton.styleFrom(
            //       side: const BorderSide(
            //         width: 2,
            //         color: AppColors.mainColor1,
            //       ),
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 40,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //     ),
            //     onPressed: () {},
            //     child: const Text("SIGN OUT",
            //         style: TextStyle(
            //             fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  // Row buildNotificationOptionRow(String title, bool isActive) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         title,
  //         style: TextStyle(
  //             fontSize: 18,
  //             fontWeight: FontWeight.w500,
  //             color: Colors.grey[600]),
  //       ),
  //       Transform.scale(
  //           scale: 0.7,
  //           child: CupertinoSwitch(
  //             value: isActive,
  //             activeColor: AppColors.mainColor2,
  //             onChanged: (bool val) {
  //               setState(() {
  //                 isActive = val;
  //               });
  //             },
  //           ))
  //     ],
  //   );
  // }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
