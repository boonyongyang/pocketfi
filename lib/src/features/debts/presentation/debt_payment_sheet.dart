import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/debts/application/debt_services.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';

class DebtPaymentSheet extends ConsumerStatefulWidget {
  const DebtPaymentSheet({
    super.key,
    required this.debt,
    required this.rowData,
    this.previousRowData,
  });

  final Debt debt;
  final Map<String, dynamic> rowData;
  final Map<String, dynamic>? previousRowData;

  @override
  DebtPaymentSheetState createState() => DebtPaymentSheetState();
}

class DebtPaymentSheetState extends ConsumerState<DebtPaymentSheet> {
  @override
  Widget build(BuildContext context) {
    double totalPayment = double.parse(widget.rowData['interest']) +
        double.parse(widget.rowData['principle']);
    double debtAmount = double.parse(widget.rowData['principle']) +
        double.parse(widget.rowData['endBalance']);
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
                  '${widget.rowData['month']} Payment',
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
            'Planned Payment',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(totalPayment.toStringAsFixed(2),
              style: const TextStyle(
                color: AppColors.mainColor2,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Previous Balance',
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        widget.previousRowData == null
                            ? Text(
                                'RM ${debtAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.mainColor1,
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                'RM ${widget.previousRowData!['endBalance']}',
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
                          'Interest',
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'RM ${widget.rowData['interest']}',
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
                          'Principle',
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'RM ${widget.rowData['principle']}',
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
                          'New Balance',
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'RM ${widget.rowData['endBalance']}',
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
          // const SizedBox(
          //   height: 10,
          // ),
          FullWidthButtonWithText(
            text: 'Mark Complete',
            onPressed: () {
              _addPaidDebt(
                widget.debt.debtId,
                double.parse(widget.rowData['interest']),
                double.parse(widget.rowData['principle']),
                double.parse(widget.rowData['endBalance']),
                widget.previousRowData == null
                    ? debtAmount
                    : double.parse(widget.previousRowData!['endBalance']),
                widget.rowData['month'],
                widget.debt.walletId,
                ref,
              );
              // Navigator.pop(context);
            },
            backgroundColor: AppColors.mainColor2,
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
  Future<void> _addPaidDebt(
    String debtId,
    double interestAmount,
    double principleAmount,
    double newBalance,
    double previousBalance,
    String paidMonth,
    String walletId,
    WidgetRef ref,
  ) async {
    // await _debtRepository.addPaidDebt(debt);
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      return;
    }

    final isCreated = await ref.read(debtPaymentProvider.notifier).addPaidDebt(
        debtId: debtId,
        userId: userId,
        interestAmount: interestAmount,
        principleAmount: principleAmount,
        newBalance: newBalance,
        previousBalance: previousBalance,
        paidMonth: paidMonth,
        walletId: walletId);

    debugPrint('paidMonth: $paidMonth');
    debugPrint('isCreated: $isCreated');
    debugPrint('mounted: $mounted');
    if (isCreated && mounted) {
      Navigator.pop(context);
    }
  }
}
