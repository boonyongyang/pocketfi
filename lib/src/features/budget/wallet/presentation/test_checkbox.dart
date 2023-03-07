import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_info_model_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/set_user_provider.dart';
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
  bool _value = false;

  @override
  void initState() {
    super.initState();
    // _isChecked = List<bool>.filled(checkListItems.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(usersListProvider).value?.toList();
    // final userss = ref.watch(usersListProvider).value;
    // for (var element in userss!) {
    //   debugPrint('userss element: $element');

    //   // userMap[element].add('isChecked': false);
    // }
    // final userMap = ref
    //     .watch(setBoolValueProvider.notifier)
    //     .changeToList(users, currentUserId!);

    final userList = ref.watch(getTempDataProvider).value?.toList();
    // final userList = ref.watch(getTempDataProvider).value;
    List userMap = [];
    // List multipleSelected = [];
    if (userList == null) return Container();
    for (var user in userList) {
      userMap.add(user);
      debugPrint('add user: $user');
      // userMap[element].add('isChecked': false);
    }
    // if (users == null) return Container();
    // for (var user in users) {
    //   userMap.add(user);
    //   debugPrint('add user: $user');
    //   // userMap[element].add('isChecked': false);
    // }
    // for (var element in userMap) {
    //   element['isChecked'] = null;
    //   debugPrint('element: $element');
    // }

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
                      // selected: ,
                      // value: _value,
                      onChanged: (bool? newValue) {
                        // eachUser.isChecked = newValue!;
                        // setState(() {
                        // debugPrint('userMap check: $userMap');
                        // if (userMap[index]['isChecked'] == null) {
                        //   userMap[index]['isChecked'] = false;
                        // }
                        // debugPrint('userMap done check: $userMap');
                        debugPrint('value: $newValue');
                        debugPrint('userMap before: $userMap');
                        // if (newValue == true) {
                        //   userMap[index]['isChecked'] = newValue;
                        // } else if (newValue == false) {
                        //   userMap[index]['isChecked'] = newValue;
                        // }
                        // });
                        newValue ??= false;

                        ref
                            .watch(setBoolValueProvider.notifier)
                            .updateIsChecked(eachUser, newValue);

                        debugPrint('userMap after: $userMap');
                        debugPrint('value after: $newValue');

                        // debugPrint('eachUser.ischecked ; ${eachUser.isChecked}');
                        // debugPrint('_value ; $_value');
                        // for (var element in userMap) {
                        //   element['isChecked'] = false;
                        // }
                        // debugPrint('eachUser.isChecked: ${eachUser.isChecked}');

                        // debugPrint('newvalue ; $newValue');
                        // setState(
                        // () {
                        // debugPrint(
                        // 'eachUser.isChecked: ${eachUser.isChecked}');
                        // userMap[index]["isChecked"] = newValue;
                        // eachUser.isChecked = newValue!;
                        // for (var element in userMap) {
                        // eachUser.isChecked = newValue;
                        // debugPrint('element newValue: $element');
                        // }
                        // debugPrint(
                        // 'eachUser.isChecked: ${eachUser.isChecked}');

                        // debugPrint('eachUser after: $eachUser');
                        // debugPrint('userMap[index]after: ${userMap[index]}');
                        // debugPrint('value set: $newValue');

                        // if (newValue == null) {
                        //   eachUser.isChecked = false;
                        // }
                        // eachUser.isChecked = newValue!;
                        // if (newValue == true) {
                        //   eachUser.isChecked = false;
                        // } else {
                        //   eachUser.isChecked  = true;
                        // }
                        // // _value = newValue!;
                        // // debugPrint('_value with setstate ; $_value');
                        // debugPrint('newvalue with setstate; $newValue');
                        // debugPrint(
                        //     'eachUser.ischecked with new value ; ${eachUser.isChecked}');
                        // if (eachUser.isChecked == true) {
                        //   eachUser.isChecked = false;
                        //   eachUser.isChecked = newValue;
                        // } else {
                        //   eachUser.isChecked = true;
                        //   eachUser.isChecked = newValue;
                        // }
                        // eachUser.isChecked = val!;
                        // debugPrint('${userMap[index]['isChecked']}');

                        // debugPrint('_value after setstate; $_value');
                        // debugPrint(
                        //     'eachUser.ischecked after setstate; ${eachUser.isChecked}');
                        // debugPrint('newvalue after setstate; $newValue');
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

    //   itemCount: userMap.length,
    //   itemBuilder: (context, index) {
    // return CheckboxListTile(
    //   tristate: true,
    //   title: Text(eachUser.displayName),
    //   // subtitle: Text(checkListItems[index]["id"]),
    //   // selected: ,
    //   // value: eachUser.isChecked,
    //   value: _value,
    //   onChanged: (bool? newValue) {
    //     // debugPrint('eachUser.ischecked ; ${eachUser.isChecked}');
    //     debugPrint('_value ; $_value');
    //     debugPrint('newvalue ; $newValue');
    //     setState(
    //       () {
    //         // eachUser.isChecked = newValue!;
    //         if (newValue == null) {
    //           _value = false;
    //         }
    //         // if (newValue == true) {
    //         //   _value = false;
    //         // } else {
    //         //   _value = true;
    //         // }
    //         _value = newValue!;
    //         debugPrint('_value with setstate ; $_value');
    //         debugPrint('newvalue with setstate; $newValue');
    //         // debugPrint(
    //         //     'eachUser.ischecked with new value ; ${eachUser.isChecked}');
    //         // if (eachUser.isChecked == true) {
    //         //   eachUser.isChecked = false;
    //         //   eachUser.isChecked = newValue;
    //         // } else {
    //         //   eachUser.isChecked = true;
    //         //   eachUser.isChecked = newValue;
    //         // }
    //         // eachUser.isChecked = val!;
    //         // debugPrint('${userMap[index]['isChecked']}');
    //         // if (multipleSelected.contains(eachUser)) {
    //         //   multipleSelected.remove(eachUser);
    //         // } else {
    //         //   multipleSelected.add(eachUser);
    //         // }
    //         // debugPrint('$multipleSelected');
    //       },
    //     );
    //     debugPrint('_value after setstate; $_value');
    //     debugPrint('newvalue after setstate; $newValue');
    //     // debugPrint(
    //     //     'eachUser.ischecked after setstate; ${eachUser.isChecked}');
    //   },
    // );
    // },
    // );
    // }
    // child: ListView.builder(
    //   itemCount: userMap.length,
    //   itemBuilder: (context, index) {
    //     final eachUser = userMap.elementAt(index);
    //     return CheckboxListTile(
    //       tristate: true,
    //       title: Text(eachUser.displayName),
    //       // subtitle: Text(checkListItems[index]["id"]),
    //       // selected: ,
    //       // value: eachUser.isChecked,
    //       value: _value,
    //       onChanged: (bool? newValue) {
    //         // debugPrint('eachUser.ischecked ; ${eachUser.isChecked}');
    //         debugPrint('_value ; $_value');
    //         debugPrint('newvalue ; $newValue');
    //         setState(
    //           () {
    //             // eachUser.isChecked = newValue!;
    //             _value = newValue!;
    //             debugPrint('_value with setstate ; $_value');
    //             debugPrint('newvalue with setstate; $newValue');
    //             // debugPrint(
    //             //     'eachUser.ischecked with new value ; ${eachUser.isChecked}');
    //             // if (eachUser.isChecked == true) {
    //             //   eachUser.isChecked = false;
    //             //   eachUser.isChecked = newValue;
    //             // } else {
    //             //   eachUser.isChecked = true;
    //             //   eachUser.isChecked = newValue;
    //             // }
    //             // eachUser.isChecked = val!;
    //             // debugPrint('${userMap[index]['isChecked']}');
    //             // if (multipleSelected.contains(eachUser)) {
    //             //   multipleSelected.remove(eachUser);
    //             // } else {
    //             //   multipleSelected.add(eachUser);
    //             // }
    //             // debugPrint('$multipleSelected');
    //           },
    //         );
    //         debugPrint('_value after setstate; $_value');
    //         debugPrint('newvalue after setstate; $newValue');
    //         // debugPrint(
    //         //     'eachUser.ischecked after setstate; ${eachUser.isChecked}');
    //       },
    //     );
    //   },
    // ),

    //   },
    //   loading: () => const LoadingAnimationView(),
    //   error: (error, stack) => const ErrorAnimationView(),
    // );
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
