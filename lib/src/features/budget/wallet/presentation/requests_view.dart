import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/small_error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_info_model_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/budget/wallet/data/add_shared_wallet_to_collaborator.dart';
import 'package:pocketfi/src/features/budget/wallet/data/check_request.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/test_pop_request.dart';

class RequestsView extends ConsumerWidget {
  const RequestsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider);
    // final isPending =
    //     ref.watch(checkRequestProvider.notifier).checkRequest(currentUserId!);
    final walletRequests = ref.watch(getPendingRequestProvider);
    // print ispending
    // isPending.then((value) => print('isPending: $value'));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Requests'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            return await ref.refresh(getPendingRequestProvider);
          },
          child: SafeArea(
            // child: Text('Requests'),
            child: walletRequests.when(
              data: (walletRequests) {
                if (walletRequests.isEmpty) {
                  // Navigator.of(context).pop();
                  return const EmptyContentsWithTextAnimationView(
                    text: 'No pending requests',
                  );
                } else {
                  return ListView.builder(
                    itemCount: walletRequests.length,
                    itemBuilder: (context, index) {
                      final walletRequest = walletRequests.elementAt(index);
                      final userInfo = ref
                          .watch(userInfoModelProvider(walletRequest.userId));
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.subColor2,
                            child: Icon(
                              AppIcons.wallet,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            walletRequest.walletName.toString(),
                          ),
                          // subtitle: Text(
                          //   'Invited by ${userInfo.value!.displayName} (${userInfo.value!.email})',
                          // ),
                          trailing: const Chip(
                            label: Text('Pending'),
                          ),
                          onTap: () async {
                            final requestWallet = await RequestDialog(
                              walletName: walletRequest.walletName,
                              inviterName: userInfo.value!.displayName,
                              inviterEmail: userInfo.value!.email,
                            ).present(context);
                            if (requestWallet == null) return;

                            if (requestWallet == true) {
                              // update the firebase
                              // final update =
                              ref
                                  .watch(checkRequestProvider.notifier)
                                  .updateStatus(
                                    CollaborateRequestStatus.accepted.name,
                                    currentUserId!,
                                    walletRequest.userId,
                                    walletRequest.walletId,
                                  );
                            } else if (requestWallet == false) {
                              // update the firebase
                              // final update =
                              ref
                                  .watch(checkRequestProvider.notifier)
                                  .updateStatus(
                                    CollaborateRequestStatus.rejected.name,
                                    currentUserId!,
                                    walletRequest.userId,
                                    walletRequest.walletId,
                                  );
                            }
                            // if (await update == true) {
                            // ref
                            //     .watch(addSharedWalletToCollaboratorProvider
                            //         .notifier)
                            //     .addSharedWalletToCollaborator(
                            //       currentUserId: currentUserId!,
                            //       walletId: walletRequest.walletId,
                            //       walletName: walletRequest.walletName,
                            //       ownerId: walletRequest.userId,
                            //       ownerName: userInfo.value!.displayName,
                            //       ownerEmail: userInfo.value!.email,
                            //       createdAt: walletRequest.createdAt,
                            //       collaborators: walletRequest.collaborators,
                            //     );
                            // }
                            // add the wallet to the collaborator}
                          },
                        ),
                      );
                    },
                  );
                }
              },
              error: (error, stack) => const ErrorAnimationView(),
              loading: () => const LoadingAnimationView(),
            ),
          ),
        ));
    //  ListView.builder(
    //     itemCount: ss,
    //     itemBuilder: (context, index) {
    //       return ListTile(
    //         title: Text('Request $index'),
    //         trailing: const Icon(Icons.arrow_forward_ios),
    //         onTap: () {},
    //       );
    //     }),
    // );
  }
}
