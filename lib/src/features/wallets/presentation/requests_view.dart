import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_info_model_provider.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';
import 'package:pocketfi/src/features/wallets/data/check_request_service.dart';
import 'package:pocketfi/src/features/wallets/presentation/test_pop_request.dart';

class RequestsView extends ConsumerWidget {
  const RequestsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(userIdProvider);
    final walletRequests = ref.watch(getPendingRequestProvider);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Requests'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            return await ref.refresh(getPendingRequestProvider);
          },
          child: SafeArea(
            child: walletRequests.when(
              data: (walletRequests) {
                if (walletRequests.isEmpty) {
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
                              ref
                                  .watch(checkRequestProvider.notifier)
                                  .updateStatus(
                                    CollaborateRequestStatus.accepted.name,
                                    currentUserId!,
                                    walletRequest.userId,
                                    walletRequest.walletId,
                                  );
                            } else if (requestWallet == false) {
                              ref
                                  .watch(checkRequestProvider.notifier)
                                  .updateStatus(
                                    CollaborateRequestStatus.rejected.name,
                                    currentUserId!,
                                    walletRequest.userId,
                                    walletRequest.walletId,
                                  );
                            }
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
  }
}
