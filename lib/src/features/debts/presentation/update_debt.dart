import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/delete_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/debts/application/debt_services.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';
import 'package:pocketfi/src/features/debts/presentation/debt_overview_view.dart';

class UpdateDebt extends StatefulHookConsumerWidget {
  Debt debt;
  UpdateDebt({
    super.key,
    required this.debt,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateDebtViewState();
}

class _UpdateDebtViewState extends ConsumerState<UpdateDebt> {
  String _selectedRecurrence = 'Monthly';
  @override
  Widget build(BuildContext context) {
    final debtNameController = useTextEditingController(
      text: widget.debt.debtName,
    );
    final totalDebtAmountController = useTextEditingController(
      text: widget.debt.debtAmount.toStringAsFixed(2),
    );
    final annualInterestRateController = useTextEditingController(
      text: widget.debt.annualInterestRate.toString(),
    );
    final minimumPaymentController = useTextEditingController(
      text: widget.debt.minimumPayment.toStringAsFixed(2),
    );

    final isCreateButtonEnabled = useState(false);

    useEffect(() {
      void listener() {
        final isDebtNameEmpty = debtNameController.text.isEmpty;
        final isTotalDebtAmountEmpty = totalDebtAmountController.text.isEmpty;
        final isAnnualInterestRateEmpty =
            annualInterestRateController.text.isEmpty;
        final isMinimumPaymentEmpty = minimumPaymentController.text.isEmpty;

        isCreateButtonEnabled.value = !isDebtNameEmpty &&
            !isTotalDebtAmountEmpty &&
            !isAnnualInterestRateEmpty &&
            !isMinimumPaymentEmpty;
      }

      debtNameController.addListener(listener);
      totalDebtAmountController.addListener(listener);
      annualInterestRateController.addListener(listener);
      minimumPaymentController.addListener(listener);

      return () {
        debtNameController.removeListener(listener);
        totalDebtAmountController.removeListener(listener);
        annualInterestRateController.removeListener(listener);
        minimumPaymentController.removeListener(listener);
      };
    }, [
      debtNameController,
      totalDebtAmountController,
      annualInterestRateController,
      minimumPaymentController,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.debt.debtName),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_rounded),
            onPressed: () async {
              final deletePost = await const DeleteDialog(
                titleOfObjectToDelete: 'Debt',
              ).present(context);
              if (deletePost == null) return;

              if (deletePost) {
                await ref.read(debtProvider.notifier).deleteDebt(
                    debtId: widget.debt.debtId,
                    userId: widget.debt.userId,
                    walletId: widget.debt.walletId);
                if (mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              }
            },
          ),
        ],
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Column(
              children: [
                // add the years to finish paying
                // Padding(
                //   padding: const EdgeInsets.only(
                //     top: 16.0,
                //     bottom: 8.0,
                //     left: 8.0,
                //     right: 8.0,
                //   ),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: const BorderRadius.all(
                //         Radius.circular(20),
                //       ),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.5),
                //           spreadRadius: 2,
                //           blurRadius: 7,
                //           offset:
                //               const Offset(3, 6), // changes position of shadow
                //         ),
                //       ],
                //     ),
                //     child: Padding(
                //       padding: const EdgeInsets.all(
                //         8.0,
                //       ),
                //       child: Column(
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: const [
                //               Text(
                //                 'Years to Finish Paying',
                //                 style: TextStyle(
                //                   color: AppColors.mainColor1,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //                 // textAlign: TextAlign.center,
                //               ),
                //             ],
                //           ),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Text(
                //                 '${calculateDebtLoan(
                //                   totalDebtAmount: widget.debt.debtAmount,
                //                   annualInterestRate:
                //                       widget.debt.annualInterestRate,
                //                   minPaymentPerMonth:
                //                       widget.debt.minimumPayment,
                //                 ).toString()} months',
                //                 // widget.debt.debtAmount.toStringAsFixed(2),
                //                 style: const TextStyle(
                //                   color: AppColors.mainColor1,
                //                   // fontWeight: FontWeight.bold,
                //                   fontSize: 30,
                //                 ),
                //                 // textAlign: TextAlign.center,
                //               ),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: FaIcon(
                          FontAwesomeIcons.moneyCheckDollar,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: debtNameController,
                          decoration: const InputDecoration(
                            labelText: 'Debt Name',
                          ),
                          autofocus: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          Icons.attach_money,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: totalDebtAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Total Debt Amount',
                            prefixText: 'RM ',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          Icons.money_rounded,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: minimumPaymentController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Minimum Payment',
                            prefixText: 'RM ',

                            // suffixText: '%',
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          Icons.percent_rounded,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: annualInterestRateController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Annual Interest Rate',
                            suffixText: '%',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Row(
                //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Padding(
                //       padding: EdgeInsets.only(left: 16.0, right: 32.0),
                //       child: SizedBox(
                //         width: 5,
                //         child: Icon(
                //           Icons.date_range_rounded,
                //           color: AppColors.mainColor1,
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: DropdownButton(
                //         items: const [
                //           DropdownMenuItem(
                //             value: 'Every 2 Weeks',
                //             child: Text('Every 2 Weeks'),
                //           ),
                //           DropdownMenuItem(
                //             value: 'Monthly',
                //             child: Text('Monthly'),
                //           ),
                //           // DropdownMenuItem(
                //           //   value: 'Every Year',
                //           //   child: Text('Every Year'),
                //           // ),
                //         ],
                //         onChanged: (value) {
                //           setState(() {
                //             _selectedRecurrence = value!;
                //           });
                //         },
                //         value: _selectedRecurrence,
                //       ),
                //     ),
                //   ],
                // ),

                //! add wallet here
              ],
            ),
          ),
          FullWidthButtonWithText(
            text: Strings.saveChanges,
            onPressed: () {
              _updateDebtController(
                debtNameController,
                totalDebtAmountController,
                annualInterestRateController,
                minimumPaymentController,
                widget.debt,
                ref,
              );
            },
            // isCreateButtonEnabled.value
            //     ? () async {
            //         _addDebtController(
            //           debtNameController,
            //           totalDebtAmountController,
            //           annualInterestRateController,
            //           minimumPaymentController,
            //           _selectedRecurrence,
            //           ref,
            //         );
            //       }
            //     : null
          ),
        ],
      ),
    );
  }

  Future<void> _updateDebtController(
    TextEditingController debtNameController,
    TextEditingController totalDebtAmountController,
    TextEditingController annualInterestRateController,
    TextEditingController minimumPaymentController,
    Debt debt,
    // Wallet selectedWallet,
    // String recurring,
    WidgetRef ref,
  ) async {
    // final userId = ref.watch(userIdProvider);
    final debtName = debtNameController.text;
    final debtAmount = double.parse(totalDebtAmountController.text);
    final annualInterestRate = double.parse(annualInterestRateController.text);
    final minimumPayment = double.parse(minimumPaymentController.text);

    final totalMonthsToPay = calculateDebtLoanDuration(
      totalDebtAmount: debtAmount,
      minPaymentPerMonth: minimumPayment,
      annualInterestRate: annualInterestRate,
    );

    final isCreated = await ref.read(debtProvider.notifier).updateDebt(
          debtId: debt.debtId,
          userId: debt.userId,
          walletId: debt.walletId,
          debtName: debtName,
          debtAmount: debtAmount,
          minimumPayment: minimumPayment,
          annualInterestRate: annualInterestRate,
          totalNumberOfMonthsToPay: totalMonthsToPay,
        );
    if (isCreated && mounted) {
      debtNameController.clear();
      totalDebtAmountController.clear();
      annualInterestRateController.clear();
      minimumPaymentController.clear();
      Fluttertoast.showToast(
        msg: "Debt Details Updated!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP_RIGHT,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.white,
        textColor: AppColors.mainColor1,
        fontSize: 16.0,
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  int calculateDebtLoanDuration({
    required double totalDebtAmount,
    required double minPaymentPerMonth,
    required double annualInterestRate,
  }) {
    // double totalDebtAmount = 3000;
    // double minPaymentPerMonth = 200;
    // double annualInterestRate = 6.0;

    double endBalance = totalDebtAmount;
    double monthlyInterestRate = (annualInterestRate / 100) / 12;
    double interest = 0;
    double principle = 0;
    int months = 0;

    while (endBalance > 0 && endBalance > minPaymentPerMonth) {
      interest = endBalance * monthlyInterestRate;
      debugPrint('minumum payment: $minPaymentPerMonth');

      endBalance = endBalance + interest - minPaymentPerMonth;
      principle = minPaymentPerMonth - interest;
      months++;
      debugPrint('Total months: $months');
      debugPrint('Interest: $interest');
      debugPrint('endBalance: $endBalance');
      debugPrint('principle: $principle');
    }
    interest = endBalance * monthlyInterestRate;
    principle = endBalance;
    endBalance = 0.00;
    months++;
    debugPrint('Total months after : $months');
    debugPrint('Total principle: $principle');
    return months;
  }
}
