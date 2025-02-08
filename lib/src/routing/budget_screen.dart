import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/budgets/application/budget_services.dart';
import 'package:pocketfi/src/features/budgets/data/budget_repository.dart';
import 'package:pocketfi/src/features/budgets/presentation/add_new_budget.dart';
import 'package:pocketfi/src/features/budgets/presentation/budger_overview.dart';
import 'package:pocketfi/src/features/budgets/presentation/budget_details_view.dart';
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

    // final currentUserId = ref.watch(userIdProvider);
    final walletRequests = ref.watch(getPendingRequestProvider).value;
    if (walletRequests == null) {
      return Container();
    }
    // final isPending = ref.watch(checkRequestProvider.notifier).checkRequest(currentUserId!);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                isScrollControlled: true,
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
            // debugPrint('budgets: $budgets');
            // return Future.delayed(const Duration(seconds: 1));
          },
          child: Flex(
            direction: Axis.vertical,
            children: [
              // budgets.value?.isNotEmpty ?? false
              //     ?
              Expanded(
                // incorrect use of parangedatawidget
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        bottom: 0.0,
                        left: 20.0,
                        right: 20.0,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('MMMM yyyy').format(DateTime.now()),
                                style: const TextStyle(
                                  color: AppColors.mainColor1,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 23,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            // mainAxisSize: MainAxisSize.min,
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
                              FutureBuilder(
                                future: totalAmount(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<double> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      'MYR ${snapshot.data!.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppColors.mainColor1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    );
                                  } else {
                                    return const LoadingAnimationView();
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                            future: spentPercentage(),
                            builder: (BuildContext context,
                                AsyncSnapshot<double> snapshot) {
                              if (snapshot.hasData) {
                                final percentage = snapshot.data! * 100;
                                return
                                    // Text(percentage.toStringAsFixed(2));
                                    Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: LinearProgressIndicator(
                                        minHeight: 25,
                                        value: snapshot.data == 0
                                            ? 0
                                            : snapshot.data,
                                        backgroundColor: Colors.grey[300],
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          AppColors.subColor1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                        top: 4.0,
                                        bottom: 4.0,
                                      ),
                                      child: Text(
                                          '${percentage.toStringAsFixed(2)}%',
                                          style: TextStyle(
                                            color: snapshot.data! * 100 > 16
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ],
                                );
                              } else {
                                return const LoadingAnimationView();
                              }
                            },
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
                              FutureBuilder(
                                future: usedAmount(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<double> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      'MYR ${snapshot.data!.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppColors.mainColor1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    );
                                  } else {
                                    return const LoadingAnimationView();
                                  }
                                },
                              ),
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
                              FutureBuilder(
                                future: remainingAmount(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<double> snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      'MYR ${snapshot.data!.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: AppColors.mainColor1,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    );
                                  } else {
                                    return const LoadingAnimationView();
                                  }
                                },
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              // fixedSize: Size(80, 30),
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.mainColor1,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => const BudgetOverview(),
                                ),
                              );
                            },
                            child: const Text('Budget Overview'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      flex: 4,
                      child: budgets.when(data: (budgets) {
                        // debugPrint('budgets: $budgets');
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
                                Navigator.of(context, rootNavigator: true).push(
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
              // : const EmptyContentsWithTextAnimationView(
              //     text: 'No Budgets Yet, Create One!'),
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
          )),
    );
  }
}
