import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/bills/presentation/bills_tab_view.dart';
import 'package:pocketfi/src/features/debts/presentation/debt_tab_view.dart';

import '../features/saving_goals/presentation/saving_goals_tab_view.dart';

class FinancesPage extends StatefulHookConsumerWidget {
  const FinancesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FinancesPageState();
}

class _FinancesPageState extends ConsumerState<FinancesPage>
    with AutomaticKeepAliveClientMixin<FinancesPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Finances'),
          bottom: const TabBar(
            indicatorColor: AppColors.mainColor2,
            labelColor: AppColors.mainColor2,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Bills'),
              Tab(text: 'Debt'),
              // icon: FaIcon(FontAwesomeIcons.moneyCheckDollar),
              // icon: Icon(Icons.money_off_rounded),
              Tab(text: 'Saving Goals'),
              // icon: FaIcon(FontAwesomeIcons.piggyBank),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BillsTabView(),
            DebtTabView(),
            SavingGoalsTabView(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
