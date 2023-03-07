
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_info_model_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_list_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/budget/wallet/data/set_user_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';

class ShareWalletSheet extends ConsumerStatefulWidget {
  const ShareWalletSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ShareWalletSheetState();
}

class _ShareWalletSheetState extends ConsumerState<ShareWalletSheet> {
  @override
  Widget build(BuildContext context) {
    // var selectedUser = ref.watch(selectedUserProvider);
    const bool isChecked = true;
    final user = ref.watch(usersListProvider);
    // final userList = ref.watch(usersListProvider).value;
    final setUser = ref.watch(setUserProvider.notifier);
    // Map<dynamic, bool> userMap = {};
    // setUser.setInitial(List.filled(userList!.length, false));
    // userList?.forEach((element) {
    //   setUser.setCollaboratorsInfoMapValue(element, false);
    // });
    // debugPrint(checkedList.toString());
    final userList = ref.watch(getTempDataProvider).value?.toList();
    List userMap = [];
    if (userList == null) return Container();
    // for (var user in userList) {
    //   userMap.add(user);
    //   debugPrint('add user: $user');
    // }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.transparent,
                  ),
                  onPressed: null,
                  // visualDensity: VisualDensity.standard,
                ),
              ),
              const Expanded(
                child: Text(
                  'Users',
                  style: TextStyle(
                    color: AppColors.mainColor1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    // pop back
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                        subtitle: Text(eachUser.email ?? ""),
                        // subtitle: Text(eachUser.isChecked.toString()),
                        onChanged: (bool? newValue) {
                          debugPrint('value: $newValue');
                          debugPrint('userMap before: $userMap');

                          newValue ??= false;

                          ref
                              .watch(setBoolValueProvider.notifier)
                              .updateIsChecked(eachUser, newValue);

                          debugPrint('userMap after: $userMap');
                          debugPrint('value after: $newValue');
                        },
                        value: eachUser.isChecked,
                      );
                    },
                  );
                }),
              ),
            ),
            // user.when(
            //   data: (user) {
            //     return ListView.builder(
            //         itemCount: user.length,
            //         itemBuilder: (context, index) {
            //           final eachUser = user.elementAt(index);
            //           return CheckboxListTile(
            //             title: Text(
            //               eachUser.displayName,
            //             ),
            //             tristate: true,
            //             controlAffinity: ListTileControlAffinity.leading,
            //             shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.all(
            //                 Radius.circular(10),
            //               ),
            //             ),
            //             subtitle: Text(
            //               eachUser.email ?? "",
            //             ),
            //             onChanged: (bool? value) {
            //               // value = !value;
            //               setUser.setCheckList(index, value ?? false);
            //               debugPrint(setUser.checkList[index].toString());
            //             },
            //             value: setUser.checkList[index],
            //             // onTap: () {
            //             // debugPrint(
            //             //     'wallet tapped: ${selectedUser?.displayName}');
            //             // if (eachUser != selectedUser) {
            //             //   ref.read(selectedUserProvider.notifier).state =
            //             //       eachUser;
            //             // }
            //             // ref.read(selectedUserProvider.notifier).state =
            //             //     selectedUser!;
            //             // debugPrint(
            //             // 'selected wallet: ${ref.read(selectedUserProvider)?.displayName}');
            //             // },
            //           );
            //         });
            //   },
            //   loading: () => const LoadingAnimationView(),
            //   error: (error, stack) => const ErrorAnimationView(),
            // ),
          ),
        ],
      ),
    );
  }
}

class ShareWalletTiles extends StatelessWidget {
  final CollaboratorsInfo user;
  const ShareWalletTiles({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(title: Text(user.displayName)),
      // subtitle: Text('Share your wallet with your friends'),
      // trailing: Icon(Icons.arrow_forward_ios),
      // onTap: () => Navigator.of(context).pushNamed('/share_wallet'),
    );
  }
}
