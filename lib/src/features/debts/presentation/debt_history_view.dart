import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/debts/data/debt_payment_repository.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';
import 'package:pocketfi/src/features/debts/presentation/paid_debt_sheet.dart';

class DebtHistoryView extends ConsumerWidget {
  Debt debt;
  DebtHistoryView({
    super.key,
    required this.debt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtPayments = ref.watch(userDebtPaymentsProvider);
    var totalAmountPaid = 0.0;
    var totalInterestPaid = 0.0;

    final debtPaymentsList = ref.watch(userDebtPaymentsProvider).value;
    if (debtPaymentsList != null) {
      for (var debtPayment in debtPaymentsList) {
        if (debtPayment.debtId == debt.debtId) {
          totalAmountPaid += debtPayment.principleAmount;
          totalInterestPaid += debtPayment.interestAmount;
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(3, 6), // changes position of shadow
                    ),
                  ],
                ),
                // height: MediaQuery.of(context).size.height * 0.35,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Total Principle Paid',
                            style: TextStyle(
                              // fontSize: 20,
                              color: AppColors.mainColor1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            totalAmountPaid.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 30,
                              color: AppColors.mainColor2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'MYR',
                            style: TextStyle(
                              // fontSize: 20,
                              color: AppColors.mainColor1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Total Interest Paid',
                            style: TextStyle(
                              // fontSize: 20,
                              color: AppColors.mainColor1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            totalInterestPaid.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 30,
                              color: AppColors.mainColor2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'MYR',
                            style: TextStyle(
                              // fontSize: 20,
                              color: AppColors.mainColor1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            debtPayments.when(
              data: (debtPayments) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: debtPayments.length,
                  itemBuilder: (context, index) {
                    final debtPayment = debtPayments.elementAt(index);
                    return debtPayment.debtId == debt.debtId
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0),
                                child:
                                    // DebtPaymentTiles(
                                    //   debtPayment: debtPayment,
                                    // )
                                    GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => PaidDebtSheet(
                                        // rowData: rowData,
                                        // previousRowData:
                                        //     index > 0 ? tableData[index - 1] : null,
                                        debtPayment: debtPayment,
                                      ),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.0),
                                        ),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(
                                      debtPayment.paidMonth,
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.mainColor1,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // const SizedBox(
                                        //   height: 5,
                                        // ),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     const Text('Principle Paid ',
                                        //         style: TextStyle(
                                        //           color: AppColors.mainColor1,
                                        //         )),
                                        //     Text(
                                        //         'MYR ${debtPayment.principleAmount.toStringAsFixed(2)}',
                                        //         style: const TextStyle(
                                        //             color: AppColors.mainColor1,
                                        //             fontWeight: FontWeight.w500)),
                                        //   ],
                                        // ),
                                        // const SizedBox(
                                        //   height: 5,
                                        // ),
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     const Text('Interest Paid ',
                                        //         style: TextStyle(
                                        //           color: AppColors.mainColor1,
                                        //         )),
                                        //     Text(
                                        //       'MYR ${debtPayment.interestAmount.toStringAsFixed(2)}',
                                        //       style: const TextStyle(
                                        //           color: AppColors.mainColor1,
                                        //           fontWeight: FontWeight.w500),
                                        //     ),
                                        //   ],
                                        // ),
                                        const Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Total Paid ',
                                                style: TextStyle(
                                                  color: AppColors.mainColor1,
                                                )),
                                            Text(
                                              'MYR ${(debtPayment.principleAmount + debtPayment.interestAmount).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                  color: AppColors.mainColor1,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: const SizedBox(
                                      height: double.infinity,
                                      child: Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.green,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container();
                  },
                );
              },
              error: (error, stackTrace) {
                return const ErrorAnimationView();
              },
              loading: () {
                return const LoadingAnimationView();
              },
            ),
          ],
        ),
      ),
    );
  }
}
