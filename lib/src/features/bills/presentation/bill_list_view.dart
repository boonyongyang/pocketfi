import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/bills/application/bill_services.dart';
import 'package:pocketfi/src/features/bills/domain/bill.dart';
import 'package:pocketfi/src/features/bills/presentation/bill_card_view.dart';
import 'package:pocketfi/src/features/bills/presentation/bill_detail_sheet.dart';

class BillListView extends ConsumerWidget {
  final Iterable<Bill> bills;

  const BillListView({
    Key? key,
    required this.bills,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugPrint('bills length is ${bills.length}');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          // physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          itemCount: bills.length,
          itemBuilder: (context, index) {
            final bill = bills.elementAt(index);
            return BillCard(
              bill: bill,
              onTapped: () {
                ref.read(selectedBillProvider.notifier).setSelectedBill(bill);

                // show bottom sheet
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => (const BillDetailSheet()),
                );

                // Navigator.of(context, rootNavigator: true).push(
                //   MaterialPageRoute(
                //     builder: (context) => const UpdateBillPage(),
                //     fullscreenDialog: true,
                //   ),
                // );
              },
            );
          },
        ),
      ),
    );
  }
}
