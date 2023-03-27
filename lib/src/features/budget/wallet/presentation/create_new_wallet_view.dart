import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_info_model_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_list_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/budget/wallet/application/create_new_wallet_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/temp_user_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/share_wallet_sheet.dart';

class CreateNewWalletView extends StatefulHookConsumerWidget {
  // final String walletId;

  const CreateNewWalletView({
    super.key,
    // required this.walletId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewWalletViewState();
}

class _CreateNewWalletViewState extends ConsumerState<CreateNewWalletView> {
  @override
  Widget build(BuildContext context) {
    final walletNameController = useTextEditingController();
    // final initialBalanceController = useTextEditingController();

    final isCreateButtonEnabled = useState(false);
    // final request = useState(
    //   RequestForWallets(
    //     userId: widget.userId,
    //   ),
    // );
    // var selectedUser = ref.watch(selectedUserProvider);
    final currentUserId = ref.watch(userIdProvider);
    final users = ref.watch(usersListProvider).value?.toList();
    // final auth = ref.watch(authStateProvider.notifier);
    // var userEmail;
    // for (var element in users!) {
    //   element.userId == currentUserId ? userEmail = element.email : null;
    // }
    // debugPrint(userEmail);
    // final tempUser = ref.watch(getTempDataProvider).value?.toList();
    // List tempUserEmail = [];
    // for (var element in tempUser!) {
    //   tempUserEmail.add(element.email);
    // }

    final getTempData = ref.watch(getTempDataProvider).value?.toList();
    List<CollaboratorsInfo> collaboratorList = [];
    // List<TempUsers> collaboratorList = [];
    if (getTempData == null) return Container();
    // for (var data in getTempData) {
    //   ref.watch(tempDataProvider.notifier).updateIsChecked(
    //         data,
    //         false,
    //         data.userId,
    //       );
    // }
    for (var user in getTempData) {
      if (user.isChecked == true) {
        // collaboratorList.add(user);
        collaboratorList.add(CollaboratorsInfo(
          userId: user.userId,
          displayName: user.displayName,
          email: user.email,
          status: CollaborateRequestStatus.pending.name,
        ));
      }
    }
    debugPrint('collaboratorStatus: ${CollaborateRequestStatus.pending.name}');
    // for (int i = 0; i < collaboratorList.length; i++) {
    //   debugPrint('collaboratorList: ${collaboratorList}');
    // }
    debugPrint('collaboratorList: $collaboratorList');
    useEffect(
      () {
        void listener() {
          isCreateButtonEnabled.value = walletNameController.text.isNotEmpty;
        }

        walletNameController.addListener(listener);
        // initialBalanceController.addListener(listener);

        return () {
          walletNameController.removeListener(listener);
          // initialBalanceController.removeListener(listener);
        };
      },
      [
        walletNameController,
        // initialBalanceController,
      ],
    );

    return WillPopScope(
      onWillPop: () async {
        ref.watch(tempDataProvider.notifier).deleteTempDataInFirebase(
              currentUserId!,
            );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.createNewWallet),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.watch(tempDataProvider.notifier).deleteTempDataInFirebase(
                    currentUserId!,
                  );

              Navigator.pop(context);
            },
          ),
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 32.0),
                        child: SizedBox(
                          width: 5,
                          child: Icon(
                            AppIcons.wallet,
                            color: AppColors.mainColor1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: walletNameController,
                            decoration: const InputDecoration(
                              labelText: Strings.walletName,
                            ),
                            autofocus: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     const Padding(
                  //       padding: EdgeInsets.only(left: 16.0, right: 32.0),
                  //       child: SizedBox(
                  //         width: 5,
                  //         child: Icon(
                  //           Icons.money_rounded,
                  //           color: AppColors.mainColor1,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: TextField(
                  //           controller: initialBalanceController,
                  //           keyboardType: TextInputType.number,
                  //           decoration: const InputDecoration(
                  //             labelText: Strings.walletBalance,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 32.0),
                        child: SizedBox(
                          width: 5,
                          child: Icon(
                            Icons.category_rounded,
                            color: AppColors.mainColor1,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Visible Categories',
                                  style: TextStyle(
                                    color: AppColors.mainColor1,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                'XX',
                                style: TextStyle(
                                  color: AppColors.mainColor1,
                                  fontSize: 16,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.mainColor1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      ref
                          .watch(tempDataProvider.notifier)
                          .addTempDataToFirebase(
                            users,
                            currentUserId!,
                          );
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ShareWalletSheet(),
                      );
                    },
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 32.0),
                          child: SizedBox(
                            width: 5,
                            child: Icon(
                              Icons.people_alt_rounded,
                              color: AppColors.mainColor1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: const [
                                Expanded(
                                  child: Text(
                                    'Share Wallet with Other People',
                                    style: TextStyle(
                                      color: AppColors.mainColor1,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.mainColor1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // for (final user in getTempData)
                  //   if (user.isChecked == true)
                  Expanded(
                    child: ListView.builder(
                      itemCount: getTempData.length,
                      itemBuilder: (context, index) {
                        final user = getTempData[index];
                        return user.isChecked == true
                            ? ListTile(
                                dense: true,
                                leading: const CircleAvatar(
                                  backgroundColor: AppColors.mainColor2,
                                  child: Icon(
                                    Icons.person_rounded,
                                    // color: AppColors.mainColor1,
                                  ),
                                ),
                                title: Text(
                                  user.displayName,
                                ),
                                subtitle: Text(
                                  user.email!,
                                ),
                              )
                            : const SizedBox();
                      },
                      shrinkWrap: true,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FullWidthButtonWithText(
                          text: Strings.createNewWallet,
                          onPressed: isCreateButtonEnabled.value
                              ? () async {
                                  _createNewWalletController(
                                    walletNameController,
                                    collaboratorList,
                                    ref,
                                  );
                                }
                              : null),
                    ),
                  ),
                  // Expanded(
                  //   flex: 0,
                  //   child: Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: FullWidthButtonWithText(
                  //       text: 'Send email',
                  //       onPressed: () {
                  //         // sendEmail(
                  //         //   'annebelcyy15@gmail.com', auth,
                  //         //   // tempUserEmail,
                  //         // );
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (_) => const SendEmailView(),
                  //             // builder: (_) => const CheckBoxExample(),
                  //             // builder: (_) => const MyStatefulWidget(),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createNewWalletController(
    TextEditingController nameController,
    List<CollaboratorsInfo>? collaborators,
    // TextEditingController balanceController,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }

    final currentUser = ref.read(userInfoModelProvider(userId));
    List<CollaboratorsInfo> collaboratorsInfo = [];
    collaborators?.forEach((element) {
      collaboratorsInfo.add(
        CollaboratorsInfo(
          userId: element.userId,
          displayName: element.displayName,
          email: element.email,
          status: element.status,
        ),
      );
    });
    debugPrint('collaborators in create f: $collaborators');
    debugPrint('collaboratorsInfo in create f: $collaboratorsInfo');

    debugPrint('userId: $userId');
    // if (balanceController.text.isEmpty) {
    //   balanceController.text = '0.00';
    // }
    final isCreated =
        await ref.read(createNewWalletProvider.notifier).createNewWallet(
              userId: userId,
              walletName: nameController.text,
              users: collaboratorsInfo,
              ownerName: currentUser.value!.displayName,
              ownerEmail: currentUser.value!.email,
              // walletBalance: double.parse(balanceController.text),
            );
    debugPrint('isCreated: $isCreated');
    if (isCreated && mounted) {
      nameController.clear();
      // balanceController.clear();
      // Navigator.of(context).pop();
      // Beamer.of(context).beamBack();
      Navigator.of(context).maybePop();
      ref.watch(tempDataProvider.notifier).deleteTempDataInFirebase(userId);
    }
  }

  // Future<bool> _checkWalletNameExists(
  //   String nameController,
  // ) async {
  //   debugPrint(nameController);
  //   debugPrint('getWallet: ${_getWallets()}');
  //   for (var wallet in _getWallets()) {
  //     debugPrint('everywallet: ${wallet.walletName}');
  //     if (nameController == wallet.walletName) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

//   Iterable<Wallet> _getWallets() {
//     final wallets = ref.read(userWalletsProvider);
//     return wallets.maybeWhen(orElse: () => [], data: (wallets) => wallets);
//   }
}
