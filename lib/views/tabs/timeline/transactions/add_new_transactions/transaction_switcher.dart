import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketfi/views/constants/app_colors.dart';

class TransactionSwitcher extends StatefulWidget {
  const TransactionSwitcher({super.key});

  @override
  State<TransactionSwitcher> createState() => _TransactionSwitcherState();
}

class _TransactionSwitcherState extends State<TransactionSwitcher> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 45.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: const TabBar(
                // enableFeedback: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  color: AppSwatches.mainColor1,
                ),
                labelColor: AppSwatches.white,
                unselectedLabelColor: AppSwatches.mainColor1,
                tabs: [
                  Tab(
                    text: 'Expense',
                  ),
                  Tab(
                    text: 'Income',
                  ),
                  Tab(
                    text: 'Transfer',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
