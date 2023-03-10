import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mailer/mailer.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/budget/application/total_amount_provider.dart';
import 'package:pocketfi/src/features/budget/application/user_budgets_provider.dart';
import 'package:pocketfi/src/features/budget/presentation/budget_detail_view.dart';
import 'package:pocketfi/src/features/budget/presentation/budget_tile.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/wallet_sheet.dart';
import 'package:pocketfi/src/features/shared/services/send_email.dart';

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
    final totalAmount = ref.watch(totalAmountProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget'),
        actions: [
          IconButton(
            icon: const Icon(AppIcons.wallet),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const WalletSheet(),
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
          return Future.delayed(const Duration(seconds: 1));
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
                                fontSize: 20,
                              ),
                            ),
                            const Spacer(),
                            // Calculation part
                            Text(
                              // 'RM XX.XX',
                              'RM ${totalAmount?.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: AppColors.mainColor1,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            // Calculation part
                            Text(
                              'RM XX.XX left',
                              style: TextStyle(
                                color: AppColors.mainColor2,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    flex: 4,
                    child: budgets.when(data: (budgets) {
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BudgetDetailsView(
                                    budget: budget,
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
                    context.beamToNamed("createNewBudget");
                    debugPrint('totalAmount: $totalAmount');
                  },
                  // },
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: SizedBox(
                //     width: double.infinity,
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         fixedSize: const Size(80, 55),
                //         backgroundColor: AppColors.mainColor1,
                //         foregroundColor: AppColors.white,
                //         shape: const RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(
                //             Radius.circular(25),
                //           ),
                //         ),
                //       ),
                //       onPressed: () =>
                //           // {
                //           // Navigator.push(
                //           //   context,
                //           //   MaterialPageRoute(
                //           //     builder: (_) => const CreateNewBudgetView(),
                //           //   ),
                //           // );
                //           context.beamToNamed("createNewBudget"),
                //       // },
                //       child: const FullWidthButtonWithText(
                //         text: Strings.createNewBudget,
                //       ),
                //     ),
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
