import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/finance/debt/debt_page.dart';
import 'package:pocketfi/src/features/finance/saving_goals/saving_goals_page.dart';

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
          title: const Text('Finance'),
          bottom: const TabBar(
            indicatorColor: AppColors.mainColor2,
            labelColor: AppColors.mainColor2,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                icon: FaIcon(FontAwesomeIcons.moneyCheckDollar),
                // icon: Icon(Icons.money_off_rounded),
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.piggyBank),
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
