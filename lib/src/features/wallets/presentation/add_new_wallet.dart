import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_info_model_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_list_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/data/temp_user_provider.dart';
import 'package:pocketfi/src/features/wallets/presentation/share_wallet_sheet.dart';

class AddNewWallet extends StatefulHookConsumerWidget {
  const AddNewWallet({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNewWalletState();
}

class _AddNewWalletState extends ConsumerState<AddNewWallet> {
  @override
  Widget build(BuildContext context) {
    final walletNameController = useTextEditingController();
    final isCreateButtonEnabled = useState(false);
    final currentUserId = ref.watch(userIdProvider);
    final users = ref.watch(usersListProvider).value?.toList();
    final getTempData = ref.watch(getTempDataProvider).value?.toList();
    List<CollaboratorsInfo> collaboratorList = [];
    if (getTempData == null) return Container();
    for (var user in getTempData) {
      if (user.isChecked == true) {
        collaboratorList.add(CollaboratorsInfo(
          userId: user.userId,
          displayName: user.displayName,
          email: user.email,
          status: CollaborateRequestStatus.pending.name,
          isCollaborator: true,
        ));
      }
    }
    useEffect(
      () {
        void listener() {
          isCreateButtonEnabled.value = walletNameController.text.isNotEmpty;
        }

        walletNameController.addListener(listener);
        return () {
          walletNameController.removeListener(listener);
        };
      },
      [
        walletNameController,
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
          centerTitle: true,
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
                        isScrollControlled: true,
                        builder: (context) => const ShareWalletSheet(),
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
    final isCreated = await ref.read(walletProvider.notifier).addNewWallet(
          userId: userId,
          walletName: nameController.text,
          users: collaboratorsInfo,
          ownerName: currentUser.value!.displayName,
          ownerEmail: currentUser.value!.email,
        );
    if (isCreated && mounted) {
      nameController.clear();
      Navigator.of(context).maybePop();
      ref.watch(tempDataProvider.notifier).deleteTempDataInFirebase(userId);
    }
  }
}
