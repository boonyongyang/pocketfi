import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/delete_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_list_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/data/temp_user_provider.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/wallets/presentation/share_wallet_sheet.dart';

class UpdateWallet extends StatefulHookConsumerWidget {
  const UpdateWallet({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateWalletState();
}

class _UpdateWalletState extends ConsumerState<UpdateWallet> {
  @override
  Widget build(BuildContext context) {
    final selectedWallet = ref.watch(selectedWalletProvider);
    final walletNameController =
        useTextEditingController(text: selectedWallet?.walletName);
    final wallets = ref.watch(userWalletsProvider);
    final walletId = selectedWallet?.walletName == 'Personal'
        ? selectedWallet?.walletId
        : null;
    var newList = selectedWallet?.collaborators;
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
        ));
      }
    }
    return WillPopScope(
      onWillPop: () async {
        ref.watch(tempDataProvider.notifier).deleteTempDataInFirebase(
              currentUserId!,
            );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wallet Details'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref.watch(tempDataProvider.notifier).deleteTempDataInFirebase(
                    currentUserId!,
                  );
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          actions: [
            if (wallets.valueOrNull != null &&
                selectedWallet?.walletId != walletId &&
                selectedWallet?.ownerId == currentUserId)
              IconButton(
                icon: const Icon(Icons.delete_rounded),
                onPressed: () async {
                  final deletePost = await const DeleteDialog(
                    titleOfObjectToDelete: 'Wallet',
                  ).present(context);
                  if (deletePost == null) return;

                  if (deletePost) {
                    await ref
                        .read(walletProvider.notifier)
                        .deleteWallet(walletId: selectedWallet!.walletId);
                    if (mounted) {
                      Navigator.of(context).maybePop();
                    }
                  }
                },
              ),
          ],
        ),
        body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
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
                            child: selectedWallet?.walletName == 'Personal' ||
                                    selectedWallet?.ownerId != currentUserId
                                ? Text(
                                    selectedWallet!.walletName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppColors.mainColor1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : TextField(
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
                        if (selectedWallet?.ownerId == currentUserId &&
                            selectedWallet?.walletName != 'Personal') {
                          if (selectedWallet?.collaborators != null) {
                            ref
                                .watch(tempDataProvider.notifier)
                                .addTempDataToFirebase(
                                  users,
                                  currentUserId!,
                                );
                          }
                          ref
                              .watch(tempDataProvider.notifier)
                              .addTempDataDetailToFirebase(
                                selectedWallet!,
                                users,
                                currentUserId!,
                              );
                        }
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
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Share Wallet with Other People',
                                      style: TextStyle(
                                        color: AppColors.mainColor1,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  selectedWallet?.ownerId == currentUserId
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: AppColors.mainColor1,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                        dense: true,
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.mainColor2,
                          child: Icon(
                            Icons.person_rounded,
                          ),
                        ),
                        title: Text(
                          selectedWallet!.ownerName!,
                        ),
                        subtitle: Text(
                          selectedWallet.ownerEmail!,
                        ),
                        trailing: Chip(
                          label: selectedWallet.ownerId != currentUserId
                              ? const Text('Owner')
                              : const Text('You'),
                          backgroundColor: AppColors.subColor2,
                        )),
                    selectedWallet.collaborators != null
                        ? ListView.builder(
                            itemCount: selectedWallet.collaborators!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                dense: true,
                                leading: const CircleAvatar(
                                  backgroundColor: AppColors.mainColor2,
                                  child: Icon(
                                    Icons.person_rounded,
                                  ),
                                ),
                                title: Text(
                                  selectedWallet
                                      .collaborators![index].displayName,
                                ),
                                subtitle: Text(
                                  selectedWallet.collaborators![index].email!,
                                ),
                                trailing: selectedWallet
                                            .collaborators![index].status ==
                                        CollaborateRequestStatus.pending.name
                                    ? const Chip(
                                        label: Text('Pending'),
                                      )
                                    : selectedWallet
                                                .collaborators![index].status ==
                                            CollaborateRequestStatus
                                                .rejected.name
                                        ? const Chip(
                                            label: Text(
                                              'Rejected',
                                              style: TextStyle(
                                                  color: AppColors.red),
                                            ),
                                          )
                                        : currentUserId ==
                                                selectedWallet.ownerId
                                            ? GestureDetector(
                                                onTap: () async {
                                                  final deleteCollaborator =
                                                      await const DeleteDialog(
                                                    titleOfObjectToDelete:
                                                        'Collaborator',
                                                  ).present(context);
                                                  if (deleteCollaborator ==
                                                      null) return;

                                                  if (deleteCollaborator) {
                                                    newList?.removeAt(index);
                                                    ref
                                                        .read(
                                                            selectedWalletProvider
                                                                .notifier)
                                                        .updateCollaboratorInfoList(
                                                            newList!, ref);
                                                  }
                                                },
                                                child: const Icon(Icons
                                                    .remove_circle_rounded),
                                              )
                                            : const SizedBox(),
                              );
                            },
                            shrinkWrap: true,
                          )
                        : const SizedBox(),
                    selectedWallet.ownerId == currentUserId &&
                            selectedWallet.walletName != 'Personal'
                        ? Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FullWidthButtonWithText(
                                text: Strings.saveChanges,
                                onPressed: () {
                                  _updateNewWalletController(
                                    walletNameController,
                                    newList,
                                    collaboratorList,
                                    selectedWallet,
                                    ref,
                                  );
                                },
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
        ),
        // ),
      ),
    );
  }

  Future<void> _updateNewWalletController(
    TextEditingController nameController,
    List<CollaboratorsInfo>? updatedCollaborators,
    List<CollaboratorsInfo>? newCollaborators,
    Wallet selectedWallet,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    List<CollaboratorsInfo> collaboratorsInfo = [];
    newCollaborators?.forEach((element) {
      if (collaboratorsInfo
          .any((collaborator) => collaborator.userId == element.userId)) return;
      collaboratorsInfo.add(
        CollaboratorsInfo(
          userId: element.userId,
          displayName: element.displayName,
          email: element.email,
          status: CollaborateRequestStatus.pending.name,
        ),
      );
    });
    final isUpdated = await ref.read(walletProvider.notifier).updateWallet(
          userId: userId,
          walletId: selectedWallet.walletId,
          walletName: nameController.text,
          users: collaboratorsInfo,
        );
    if (isUpdated && mounted) {
      nameController.clear();
      Navigator.pop(context);
      Navigator.pop(context);
      ref.watch(tempDataProvider.notifier).deleteTempDataInFirebase(userId);
    }
  }
}
