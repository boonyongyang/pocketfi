import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/debts/application/debt_services.dart';
import 'package:pocketfi/src/features/debts/domain/debt_payments.dart';

class PaidDebtSheet extends ConsumerStatefulWidget {
  DebtPayment debtPayment;
  PaidDebtSheet({
    super.key,
    required this.debtPayment,
  });

  @override
  _PaidDebtSheetState createState() => _PaidDebtSheetState();
}

class _PaidDebtSheetState extends ConsumerState<PaidDebtSheet> {
  @override
  Widget build(BuildContext context) {
    var totalAmountPaid =
        widget.debtPayment.interestAmount + widget.debtPayment.principleAmount;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  left: 8.0,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.transparent,
                  ),
                  onPressed: null,
                ),
              ),
              Expanded(
                child: Text(
                  '${widget.debtPayment.paidMonth} Details',
                  style: const TextStyle(
                    color: AppColors.mainColor1,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.mainColor1,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Paid Amount',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(totalAmountPaid.toStringAsFixed(2),
              style: const TextStyle(
                color: AppColors.green,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              )),
          const Text(
            'MYR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.mainColor1,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(31, 120, 120, 120),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 2,
                //     blurRadius: 7,
                //     offset: const Offset(3, 6), // changes position of shadow
                //   ),
                // ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 10.0,
                  left: 45.0,
                  right: 45.0,
                ),
                child: Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const Text(
                    //       'Previous Balance',
                    //       style: TextStyle(
                    //         color: AppColors.mainColor1,
                    //         fontSize: 15,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //     widget.previousRowData == null
                    //         ? Text(
                    //             'RM ${debtAmount.toStringAsFixed(2)}',
                    //             style: const TextStyle(
                    //               color: AppColors.mainColor1,
                    //               fontSize: 15,
                    //               // fontWeight: FontWeight.bold,
                    //             ),
                    //             textAlign: TextAlign.center,
                    //           )
                    //         : Text(
                    //             'RM ${widget.previousRowData!['endBalance']}',
                    //             style: const TextStyle(
                    //               color: AppColors.mainColor1,
                    //               fontSize: 15,
                    //               // fontWeight: FontWeight.bold,
                    //             ),
                    //             textAlign: TextAlign.center,
                    //           ),
                    //   ],
                    // ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Interest Paid',
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'RM ${widget.debtPayment.interestAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Principle Paid',
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'RM ${widget.debtPayment.principleAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 15,
                            // fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 5,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const Text(
                    //       'Payment',
                    //       style: TextStyle(
                    //         color: AppColors.mainColor1,
                    //         fontSize: 15,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //     Text(
                    //       'RM ${totalPayment.toStringAsFixed(2)}',
                    //       style: const TextStyle(
                    //         color: AppColors.mainColor1,
                    //         fontSize: 15,
                    //         // fontWeight: FontWeight.bold,
                    //       ),
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Left to pay',
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'RM ${widget.debtPayment.newBalance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FullWidthButtonWithText(
            text: 'Reopen Statement',
            onPressed: () {
              _deletePaidDebt(
                widget.debtPayment.debtId,
                widget.debtPayment.debtPaymentId,
                widget.debtPayment.walletId,
                widget.debtPayment.transactionId,
                ref,
              );
              // _addPaidDebt(
              //   widget.debt.debtId,
              //   double.parse(widget.rowData['interest']),
              //   double.parse(widget.rowData['principle']),
              //   double.parse(widget.rowData['endBalance']),
              //   widget.previousRowData == null
              //       ? debtAmount
              //       : double.parse(widget.previousRowData!['endBalance']),
              //   widget.rowData['month'],
              //   ref,
              // );
              // Navigator.pop(context);
            },
            backgroundColor: Colors.grey,
          )
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: 1,
          //     itemBuilder: (BuildContext context, int index) {
          //       return const WalletTile();
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  // function to add the paid debt into
  Future<void> _deletePaidDebt(
    String debtId,
    String debtPaymentId,
    String walletId,
    String transactionId,
    WidgetRef ref,
  ) async {
    // await _debtRepository.addPaidDebt(debt);
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      return;
    }

    final isCreated =
        await ref.read(debtPaymentProvider.notifier).deletePaidDebt(
              debtId: debtId,
              userId: userId,
              debtPaymentId: debtPaymentId,
              transactionId: transactionId,
              walletId: walletId,
            );
    if (isCreated && mounted) {
      Navigator.pop(context);
    }
  }
}
