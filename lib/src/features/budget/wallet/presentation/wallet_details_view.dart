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
import 'package:pocketfi/src/features/budget/wallet/application/delete_wallet_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/application/update_wallet_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/check_request.dart';
import 'package:pocketfi/src/features/budget/wallet/data/temp_user_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/share_wallet_sheet.dart';

class WalletDetailsView extends StatefulHookConsumerWidget {
  final Wallet wallet;

  const WalletDetailsView({
    super.key,
    required this.wallet,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WalletDetailsViewState();
}

class _WalletDetailsViewState extends ConsumerState<WalletDetailsView> {
  @override
  Widget build(BuildContext context) {
    final walletNameController = useTextEditingController(
      text: widget.wallet.walletName,
    );

    final wallets = ref.watch(userWalletsProvider);
    final walletId =
        widget.wallet.walletName == 'Personal' ? widget.wallet.walletId : null;

    final currentUserId = ref.watch(userIdProvider);
    final users = ref.watch(usersListProvider).value?.toList();

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

    return
        // RefreshIndicator(
        //   onRefresh: () {
        //     return ref.refresh(userWalletsProvider as Refreshable<Future<void>>);
        //   },
        //   child:
        Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.watch(tempDataProvider.notifier).deleteTempDataInFirebase(
                  currentUserId!,
                );

            Navigator.pop(context);
          },
        ),
        actions: [
          if (wallets.valueOrNull != null &&
              widget.wallet.walletId != walletId &&
              widget.wallet.ownerId == widget.wallet.userId)
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: () async {
                final deletePost = await const DeleteDialog(
                  titleOfObjectToDelete: 'Wallet',
                ).present(context);
                if (deletePost == null) return;

                if (deletePost) {
                  await ref
                      .read(deleteWalletProvider.notifier)
                      .deleteWallet(walletId: widget.wallet.walletId);
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
                          child: widget.wallet.walletName == 'Personal' ||
                                  widget.wallet.ownerId != widget.wallet.userId
                              ? Text(
                                  widget.wallet.walletName,
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
                  // Row(
                  //   children: [
                  //     const Padding(
                  //       padding: EdgeInsets.only(left: 16.0, right: 32.0),
                  //       child: SizedBox(
                  //         width: 5,
                  //         child: Icon(
                  //           Icons.people_alt_rounded,
                  //           color: AppColors.mainColor1,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           children: const [
                  //             Expanded(
                  //               child: Text(
                  //                 'Share Wallet with Other People',
                  //                 style: TextStyle(
                  //                   color: AppColors.mainColor1,
                  //                   fontSize: 16,
                  //                 ),
                  //               ),
                  //             ),
                  //             Padding(
                  //               padding: EdgeInsets.all(8.0),
                  //               child: Icon(
                  //                 Icons.arrow_forward_ios_rounded,
                  //                 color: AppColors.mainColor1,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  GestureDetector(
                    onTap: () {
                      if (widget.wallet.ownerId == widget.wallet.userId) {
                        ref
                            .watch(tempDataProvider.notifier)
                            .addTempDataToFirebase(
                              users,
                              currentUserId!,
                            );
                        // ref
                        //     .watch(tempDataProvider.notifier)
                        //     .addTempDataToFirebaseForDetailView(
                        //       users,
                        //       currentUserId!,
                        //     );

                        showModalBottomSheet(
                          context: context,
                          builder: (context) => const ShareWalletSheet(
                              // wallet: widget.wallet,
                              ),
                        );
                      }
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
                                widget.wallet.ownerId == widget.wallet.userId
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
                          // color: AppColors.mainColor1,
                        ),
                      ),
                      title: Text(
                        widget.wallet.ownerName!,
                      ),
                      subtitle: Text(
                        widget.wallet.ownerEmail!,
                      ),
                      trailing: Chip(
                        label: widget.wallet.ownerId != widget.wallet.userId
                            ? const Text('Owner')
                            : const Text('You'),
                        backgroundColor: AppColors.subColor2,
                      )),
                  widget.wallet.collaborators != null
                      ? ListView.builder(
                          itemCount: widget.wallet.collaborators!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              leading: const CircleAvatar(
                                backgroundColor: AppColors.mainColor2,
                                child: Icon(
                                  Icons.person_rounded,
                                  // color: AppColors.mainColor1,
                                ),
                              ),
                              title: Text(
                                widget.wallet.collaborators![index].displayName,
                              ),
                              subtitle: Text(
                                widget.wallet.collaborators![index].email!,
                              ),
                              trailing: widget.wallet.collaborators![index]
                                          .status ==
                                      CollaborateRequestStatus.pending.name
                                  ? const Chip(
                                      label: Text('Pending'),
                                    )
                                  : widget.wallet.collaborators![index]
                                              .status ==
                                          CollaborateRequestStatus.rejected.name
                                      ? const Chip(
                                          label: Text(
                                            'Rejected',
                                            style:
                                                TextStyle(color: AppColors.red),
                                          ),
                                        )
                                      : widget.wallet.userId ==
                                              widget.wallet.ownerId
                                          ? GestureDetector(
                                              onTap: () async {
                                                // on press remove the collaborator
                                                final deleteCollaborator =
                                                    await const DeleteDialog(
                                                  titleOfObjectToDelete:
                                                      'Collaborator',
                                                ).present(context);
                                                if (deleteCollaborator == null)
                                                  return;

                                                if (deleteCollaborator) {
                                                  await ref
                                                      .read(checkRequestProvider
                                                          .notifier)
                                                      .removeCollaborator(
                                                        walletId: widget
                                                            .wallet.walletId,
                                                        currentUserId: widget
                                                            .wallet.userId,
                                                        collaboratorUserId:
                                                            widget
                                                                .wallet
                                                                .collaborators![
                                                                    index]
                                                                .userId,
                                                        collaboratorUserName:
                                                            widget
                                                                .wallet
                                                                .collaborators![
                                                                    index]
                                                                .displayName,
                                                        collaboratorUserEmail:
                                                            widget
                                                                .wallet
                                                                .collaborators![
                                                                    index]
                                                                .email!,
                                                        inviteeId: widget
                                                            .wallet.ownerId!,
                                                        // status: widget
                                                        //     .wallet
                                                        //     .collaborators![
                                                        //         index]
                                                        //     .status,
                                                      );
                                                }
                                              },
                                              child: const Icon(
                                                  Icons.remove_circle_rounded),
                                            )
                                          : const SizedBox(),

                              // widget.wallet.collaborators![index]
                              //             .status ==
                              //         CollaborateRequestStatus.pending.name
                              //     ? const Chip(
                              //         label: Text('Pending'),
                              //       )
                              //     : GestureDetector(
                              //         onTap: () {
                              //           // on press remove the collaborator
                              //         },
                              //         child: const Icon(
                              //             Icons.remove_circle_rounded),
                              // ),
                            );
                          },
                          shrinkWrap: true,
                        )
                      : const SizedBox(),
                  // ListView.builder(
                  //   itemCount: getTempData.length,
                  //   itemBuilder: (context, index) {
                  //     final user = getTempData[index];
                  //     return user.isChecked == true
                  //         ? ListTile(
                  //             dense: true,
                  //             leading: const CircleAvatar(
                  //               backgroundColor: AppColors.mainColor2,
                  //               child: Icon(
                  //                 Icons.person_rounded,
                  //                 // color: AppColors.mainColor1,
                  //               ),
                  //             ),
                  //             title: Text(
                  //               user.displayName,
                  //             ),
                  //             subtitle: Text(
                  //               user.email!,
                  //             ),
                  //           )
                  //         : const SizedBox();
                  //   },
                  //   shrinkWrap: true,
                  // ),

                  widget.wallet.walletId != walletId
                      ? Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FullWidthButtonWithText(
                              text: Strings.saveChanges,
                              onPressed: () {
                                _updateNewWalletController(
                                  walletNameController,
                                  collaboratorList,
                                  // initialBalanceController,
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
    );
  }

  Future<void> _updateNewWalletController(
    TextEditingController nameController,
    List<CollaboratorsInfo>? collaborators,

    // TextEditingController balanceController,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    //! need to check collaborator status. If accepted no need change status, if new one then only change pending
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
    final isUpdated =
        await ref.read(updateWalletProvider.notifier).updateWallet(
              userId: userId,
              walletId: widget.wallet.walletId,
              walletName: nameController.text,
              users: collaboratorsInfo,
              // walletBalance: double.parse(balanceController.text),
            );
    if (isUpdated && mounted) {
      nameController.clear();
      Navigator.of(context).maybePop();
      ref.watch(tempDataProvider.notifier).deleteTempDataInFirebase(userId);
    }
  }
}
