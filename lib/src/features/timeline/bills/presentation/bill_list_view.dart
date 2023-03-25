import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/timeline/bills/application/bill_services.dart';
import 'package:pocketfi/src/features/timeline/bills/domain/bill.dart';
import 'package:pocketfi/src/features/timeline/bills/presentation/bill_card_view.dart';
import 'package:pocketfi/src/features/timeline/bills/presentation/update_bill_page.dart';

class BillListView extends ConsumerWidget {
  final Iterable<Bill> bills;

  const BillListView({
    Key? key,
    required this.bills,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugPrint('bills length is ${bills.length}');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: bills.length,
      itemBuilder: (context, index) {
        final bill = bills.elementAt(index);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BillCard(
              bill: bill,
              onTapped: () {
                ref.read(selectedBillProvider.notifier).setSelectedBill(bill);

                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => const UpdateBillPage(),
                    fullscreenDialog: true,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
