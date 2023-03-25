import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/finance/debt/application/debt_providers.dart';
import 'package:pocketfi/src/features/finance/debt/domain/debt.dart';
import 'package:pocketfi/src/features/finance/debt/presentation/debt_history_view.dart';
import 'package:pocketfi/src/features/finance/debt/presentation/debt_overview_view.dart';
import 'package:pocketfi/src/features/finance/debt/presentation/upcoming_debt_view.dart';
import 'package:pocketfi/src/features/finance/debt/presentation/update_debt_view.dart';

class DebtDetailsView extends ConsumerWidget {
  Debt debt;
  DebtDetailsView({
    super.key,
    required this.debt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final selectedDebt = ref.watch(selectedDebtProvider);
    // if (selectedDebt == null) {
    //   return Container();
    // }
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(debt.debtName),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => UpdateDebtView(
                      debt: debt,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.mainColor2,
            labelColor: AppColors.mainColor2,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                // icon: FaIcon(FontAwesomeIcons.moneyCheckDollar),
                text: 'Overview',
                // icon: Icon(Icons.money_off_rounded),
              ),
              Tab(
                // icon: FaIcon(FontAwesomeIcons.piggyBank),
                text: 'Upcoming',
              ),
              Tab(
                // icon: FaIcon(FontAwesomeIcons.piggyBank),
                text: 'History',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DebtOverviewView(
              debt: debt,
            ),
            UpcomingDebtView(debt: debt),
            DebtHistoryView(
              debt: debt,
            ),
          ],
        ),
      ),
    );
  }
}
