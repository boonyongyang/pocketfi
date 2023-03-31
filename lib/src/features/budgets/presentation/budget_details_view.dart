import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/budgets/application/budget_services.dart';
import 'package:pocketfi/src/features/budgets/presentation/update_budget.dart';
import 'package:pocketfi/src/features/transactions/data/transaction_repository.dart';
import 'package:pocketfi/src/features/transactions/presentation/transactions_list_view.dart';

class BudgetDetailsView extends ConsumerWidget {
  const BudgetDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedBudget = ref.watch(selectedBudgetProvider);
    final transactions =
        ref.watch(userTransactionsInBudgetProvider(selectedBudget!.budgetId));

    return Scaffold(
        appBar: AppBar(
          title: Text(selectedBudget.budgetName),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UpdateBudget(
                        // budget: budget,
                        ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(3, 6), // changes position of shadow
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
              ),
              transactions.when(
                data: (trans) {
                  if (trans.isEmpty) {
                    return const EmptyContentsWithTextAnimationView(
                      text: Strings.youHaveNoPosts,
                    );
                  } else {
                    return TransactionListView(
                      transactions: trans,
                    );
                  }
                },
                error: (error, stackTrace) {
                  return const ErrorAnimationView();
                },
                loading: () {
                  return const LoadingAnimationView();
                },
              ),
            ],
          ),
        ));
  }
}
