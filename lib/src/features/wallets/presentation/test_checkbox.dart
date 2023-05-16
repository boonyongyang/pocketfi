import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/wallets/data/temp_user_provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(userIdProvider);
    final userList = ref.watch(getTempDataProvider).value?.toList();
    List userMap = [];
    if (userList == null) return Container();
    for (var user in userList) {
      userMap.add(user);
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
                        newValue ??= false;
                        ref.watch(tempDataProvider.notifier).updateIsChecked(
                              eachUser,
                              newValue,
                              currentUserId!,
                            );
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
                    setState(() {
                      checkListItems[index]["value"] = value;
                      if (multipleSelected.contains(checkListItems[index])) {
                        multipleSelected.remove(checkListItems[index]);
                      } else {
                        multipleSelected.add(checkListItems[index]);
                      }
                    });
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
