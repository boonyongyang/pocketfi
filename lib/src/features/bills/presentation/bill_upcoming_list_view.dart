import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/features/bills/data/bill_repository.dart';
import 'package:pocketfi/src/features/bills/domain/bill.dart';
import 'package:pocketfi/src/features/bills/presentation/bill_list_view.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';

class BillUpcomingListView extends ConsumerWidget {
  const BillUpcomingListView({
    super.key,
    required this.userBills,
  });

  final AsyncValue<Iterable<Bill>> userBills;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userBillsProvider);
        ref.refresh(overviewMonthProvider.notifier).resetMonth();
        debugPrint('refresh bills');
        return Future.delayed(
          const Duration(milliseconds: 500),
        );
      },
      child: userBills.when(
        data: (bills) {
          if (bills.isEmpty) {
            return const EmptyContentsWithTextAnimationView(
              text:
                  '\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t No bills yet. \n Click the button to add a bill.',
            );
          } else {
            // final overdueAndUnpaidBills = bills.where(
            //   (bill) => bill.status != BillStatus.paid,
            // );

            // final overdueBills =
            //     bills.where((bill) => bill.status == BillStatus.overdue);
            // final unpaidBills =
            //     bills.where((bill) => bill.status == BillStatus.unpaid);

            final overdueBills = bills
                .where((bill) => bill.status == BillStatus.overdue)
                .toList()
              ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

            final unpaidBills = bills
                .where((bill) => bill.status == BillStatus.unpaid)
                .toList()
              ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

            return Column(
              children: [
                if (overdueBills.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text('Overdue',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: BillStatus.unpaid.color)),
                      ),
                      BillListView(bills: overdueBills),
                    ],
                  ),
                if (unpaidBills.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text('Upcoming',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: BillStatus.unpaid.color)),
                      ),
                      BillListView(bills: unpaidBills),
                    ],
                  ),
              ],
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
    );
  }
}
