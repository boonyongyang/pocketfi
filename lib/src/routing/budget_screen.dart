import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budgets/application/budget_services.dart';
import 'package:pocketfi/src/features/budgets/data/budget_repository.dart';
import 'package:pocketfi/src/features/budgets/presentation/add_new_budget.dart';
import 'package:pocketfi/src/features/budgets/presentation/budget_details_view.dart';
import 'package:pocketfi/src/features/budgets/presentation/update_budget.dart';
import 'package:pocketfi/src/features/budgets/presentation/budget_tile.dart';
import 'package:pocketfi/src/features/wallets/data/check_request_service.dart';
import 'package:pocketfi/src/features/wallets/presentation/requests_view.dart';
import 'package:pocketfi/src/features/wallets/presentation/wallet_bottom_sheet.dart';

class BudgetPage extends ConsumerStatefulWidget {
  const BudgetPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BudgetPageState();
}

class _BudgetPageState extends ConsumerState<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    final budgets = ref.watch(userBudgetsProvider);
    final totalAmount = ref.watch(totalAmountProvider);
    final usedAmount = ref.watch(usedAmountProvider);
    final remainingAmount = ref.watch(remainingAmountProvider);
    final amountPercentage = ref.watch(amountPercentageProvider);
    // calcualte remaining amount

    final currentUserId = ref.watch(userIdProvider);
    final walletRequests = ref.watch(getPendingRequestProvider).value;
    if (walletRequests == null) {
      return Container();
    }
    // final isPending =
    //     ref.watch(checkRequestProvider.notifier).checkRequest(currentUserId!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        actions: [
          IconButton(
            icon: walletRequests.isNotEmpty
                ? const Icon(
                    Icons.notifications_active_rounded,
                    color: AppColors.mainColor2,
                  )
                : const Icon(
                    Icons.notifications_rounded,
                  ),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => const RequestsView(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(AppIcons.wallet),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const WalletBottomSheet(),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                ),
              );
            },
            // {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     // builder: (_) => const WalletPage(),
            //     builder: (_) => const CreateNewWalletView(),
            //   ),
            // );

            // context.beamToNamed("wallet"),
            // },
            // BeamerButton(
            //   beamer: beamer,
            //   uri: '/budget/wallet',
            //   child: const Icon(Icons.wallet),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(userBudgetsProvider);
          debugPrint('budgets: $budgets');
          // return Future.delayed(const Duration(seconds: 1));
        },
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                color: AppColors.mainColor1,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            // Calculation part
                            totalAmount.when(
                              data: (totalAmount) => Text(
                                // 'RM XX.XX',
                                'RM ${totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.mainColor1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              loading: () => const LoadingAnimationView(),
                              error: (error, stack) =>
                                  const ErrorAnimationView(),
                            ),
                            // Text(
                            //   // 'RM XX.XX',
                            //   'RM ${totalAmount.toStringAsFixed(2)}',
                            //   style: const TextStyle(
                            //     color: AppColors.mainColor1,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 20,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            //progress indicator\
                            // amountPercentage.when(
                            //   data: (amountPercentage) {
                            //     debugPrint(
                            //         'amountPercentage: $amountPercentage');
                            //     return Expanded(
                            //       child: ClipRRect(
                            //         borderRadius: BorderRadius.circular(10.0),
                            //         child: LinearProgressIndicator(
                            //           minHeight: 10,
                            //           value: amountPercentage,
                            //           backgroundColor: Colors.grey[300],
                            //           valueColor:
                            //               const AlwaysStoppedAnimation<Color>(
                            //             AppColors.subColor1,
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   },
                            //   loading: () => const LoadingAnimationView(),
                            //   error: (error, stack) =>
                            //       const ErrorAnimationView(),
                            // ),
                            // Expanded(
                            //   child: ClipRRect(
                            //     borderRadius: BorderRadius.circular(10.0),
                            //     child: LinearProgressIndicator(
                            //       minHeight: 10,
                            //       value: totalAmount / usedAmount,
                            //       backgroundColor: Colors.grey[300],
                            //       valueColor: AlwaysStoppedAnimation<Color>(
                            //         AppColors.mainColor1,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Calculation part
                            const Text(
                              'Spent',
                              style: TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            usedAmount.when(data: (data) {
                              return Text(
                                'MYR ${data.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              );
                            }, loading: () {
                              return const LoadingAnimationView();
                            }, error: (error, stack) {
                              return const ErrorAnimationView();
                            }),
                            // Text(
                            //   'MYR ${usedAmount.toStringAsFixed(2)}',
                            //   style: const TextStyle(
                            //     color: AppColors.green,
                            //     fontWeight: FontWeight.bold,
                            //     fontSize: 15,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Calculation part
                            const Text(
                              'Left',
                              style: TextStyle(
                                color: AppColors.mainColor2,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            remainingAmount.when(data: (data) {
                              return Text(
                                'MYR ${data.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.mainColor2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              );
                            }, loading: () {
                              return const LoadingAnimationView();
                            }, error: (error, stack) {
                              return const ErrorAnimationView();
                            }),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: const [
                        //     // Calculation part
                        //     Text(
                        //       'RM XX.XX left',
                        //       style: TextStyle(
                        //         color: AppColors.mainColor2,
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 20,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    flex: 4,
                    child: budgets.when(data: (budgets) {
                      debugPrint('budgets: $budgets');
                      if (budgets.isEmpty) {
                        return const SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: EmptyContentsWithTextAnimationView(
                              text: Strings.noBudgetsYet),
                        );
                      }
                      return ListView.builder(
                        itemCount: budgets.length,
                        itemBuilder: (context, index) {
                          final budget = budgets.elementAt(index);
                          return BudgetTile(
                            budget: budget,
                            onTap: () {
                              ref
                                  .read(selectedBudgetProvider.notifier)
                                  .setSelectedBudget(budget, ref);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BudgetDetailsView(
                                      // budget: budget,
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }, error: ((error, stackTrace) {
                      return const ErrorAnimationView();
                    }), loading: () {
                      return const LoadingAnimationView();
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FullWidthButtonWithText(
                  text: Strings.createNewBudget,
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                        builder: (context) => const AddNewBudget(),
                      ),
                    );
                    // context.beamToNamed("createNewBudget");
                    debugPrint('totalAmount: $totalAmount');
                  },
                  // },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
