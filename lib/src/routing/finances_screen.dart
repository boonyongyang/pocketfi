import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/debts/presentation/debt_page.dart';

import '../features/saving_goals/presentation/saving_goals_page.dart';

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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Finances'),
          bottom: const TabBar(
            indicatorColor: AppColors.mainColor2,
            labelColor: AppColors.mainColor2,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                // icon: FaIcon(FontAwesomeIcons.moneyCheckDollar),
                text: 'Debt',
                // icon: Icon(Icons.money_off_rounded),
              ),
              Tab(
                // icon: FaIcon(FontAwesomeIcons.piggyBank),
                text: 'Saving Goals',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DebtPage(),
            SavingGoalsPage(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
