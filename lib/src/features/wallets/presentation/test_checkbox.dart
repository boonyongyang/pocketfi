import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/wallets/data/temp_user_provider.dart';
// import 'package:flutter/scheduler.dart' show timeDilation;

// class MyStatefulWidget extends StatefulWidget {
//   const MyStatefulWidget({super.key});

//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }

// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: CheckboxListTile(
//         title: const Text('Animate Slowly'),
//         value: timeDilation != 1.0,
//         onChanged: (bool? value) {
//           setState(() {
//             timeDilation = value! ? 10.0 : 1.0;
//           });
//         },
//         secondary: const Icon(Icons.hourglass_empty),
//       ),
//     );
//   }
// }
class CheckBoxInListView extends ConsumerStatefulWidget {
  const CheckBoxInListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CheckBoxInListViewState();
}

class _CheckBoxInListViewState extends ConsumerState<CheckBoxInListView> {
  @override
  void initState() {
    super.initState();
    // _isChecked = List<bool>.filled(checkListItems.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(userIdProvider);

    final userList = ref.watch(getTempDataProvider).value?.toList();
    List userMap = [];
    if (userList == null) return Container();
    for (var user in userList) {
      userMap.add(user);
      debugPrint('add user: $user');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 64.0),
        child: Column(
          children: [
            Column(
              children: List.generate(userList.length, (index) {
                final eachUser = userList[index];
                debugPrint('userMap start: $userList');
                return Consumer(
                  builder: (context, ref, child) {
                    return CheckboxListTile(
                      tristate: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: Text(eachUser.displayName),
                      subtitle: Text(eachUser.isChecked.toString()),
                      onChanged: (bool? newValue) {
                        debugPrint('value: $newValue');
                        debugPrint('userMap before: $userMap');

                        newValue ??= false;

                        ref.watch(tempDataProvider.notifier).updateIsChecked(
                              eachUser,
                              newValue,
                              currentUserId!,
                            );

                        debugPrint('userMap after: $userMap');
                        debugPrint('value after: $newValue');
                      },
                      value: eachUser.isChecked,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBoxExample extends StatefulWidget {
  const CheckBoxExample({Key? key}) : super(key: key);

  @override
  State<CheckBoxExample> createState() => _CheckBoxExampleState();
}

class _CheckBoxExampleState extends State<CheckBoxExample> {
  List multipleSelected = [];
  List checkListItems = [
    {
      "id": 0,
      "value": false,
      "title": "Sunday",
    },
    {
      "id": 1,
      "value": false,
      "title": "Monday",
    },
    {
      "id": 2,
      "value": false,
      "title": "Tuesday",
    },
    {
      "id": 3,
      "value": false,
      "title": "Wednesday",
    },
    {
      "id": 4,
      "value": false,
      "title": "Thursday",
    },
    {
      "id": 5,
      "value": false,
      "title": "Friday",
    },
    {
      "id": 6,
      "value": false,
      "title": "Saturday",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 64.0),
        child: Column(
          children: [
            Column(
              children: List.generate(
                checkListItems.length,
                (index) => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  title: Text(
                    checkListItems[index]["title"],
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  value: checkListItems[index]["value"],
                  onChanged: (value) {
                    debugPrint('value: $value');
                    setState(() {
                      debugPrint(
                          'checkListItems[index]["value"]: ${checkListItems[index]["value"]}');
                      checkListItems[index]["value"] = value;
                      debugPrint(
                          'checkListItems[index]["value"] after: ${checkListItems[index]["value"]}');
                      debugPrint('value set: $value');
                      if (multipleSelected.contains(checkListItems[index])) {
                        multipleSelected.remove(checkListItems[index]);
                      } else {
                        multipleSelected.add(checkListItems[index]);
                      }
                    });
                    debugPrint('value after: $value');
                  },
                ),
              ),
            ),
            const SizedBox(height: 64.0),
            Text(
              multipleSelected.isEmpty ? "" : multipleSelected.toString(),
              style: const TextStyle(
                fontSize: 22.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
