import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/data/user_wallets_provider.dart';
import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
import 'package:pocketfi/src/features/budget/wallet/presentation/select_wallet_dropdownlist.dart';
import 'package:pocketfi/src/features/finance/debt/application/debt_providers.dart';
import 'package:pocketfi/src/features/finance/debt/data/add_debt_notifier.dart';

class AddDebtView extends StatefulHookConsumerWidget {
  const AddDebtView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddDebtViewState();
}

class _AddDebtViewState extends ConsumerState<AddDebtView> {
  String _selectedRecurrence = 'Monthly';
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    final debtNameController = useTextEditingController();
    final totalDebtAmountController = useTextEditingController();
    final annualInterestRateController = useTextEditingController();
    final minimumPaymentController = useTextEditingController();

    final isCreateButtonEnabled = useState(false);

    final selectedWallet = ref.watch(selectedWalletForDebtProvider);

    // double? totalDebtAmount = double.tryParse(totalDebtAmountController.text);
    // double? minPaymentPerMonth = double.tryParse(minimumPaymentController.text);
    // double? annualInterestRate =
    //     double.tryParse(annualInterestRateController.text);
    var months;

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
        title: const Text('Add Debt'),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Column(
              children: [
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
                  ],
                ),
                Row(
                  children: [
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
                //             value: 'Biweekly',
                //             child: Text('Biweekly'),
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
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          AppIcons.wallet,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    // const Expanded(
                    //   child: Padding(
                    //     padding: EdgeInsets.all(16.0),
                    //     child: Text(
                    //       'Wallets',
                    //       style: TextStyle(
                    //         // color: AppSwatches.mainColor2,
                    //         // fontWeight: FontWeight.bold,
                    //         fontSize: 15,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 16.0,
                          // top: 16.0,
                          bottom: 8.0,
                        ),
                        child: SelectWalletForDebtDropdownList()),
                  ],
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     if (totalDebtAmountController.text.isNotEmpty &&
                //         minimumPaymentController.text.isNotEmpty &&
                //         annualInterestRateController.text.isNotEmpty) {
                //       setState(() {
                //         isVisible = !isVisible;
                //       });
                //       // months = calculateDebtLoanDuration(
                //       //   totalDebtAmount:
                //       //       double.parse(totalDebtAmountController.text),
                //       //   minPaymentPerMonth:
                //       //       double.parse(minimumPaymentController.text),
                //       //   annualInterestRate:
                //       //       double.parse(annualInterestRateController.text),
                //       // );
                //       // Padding(
                //       //   padding: const EdgeInsets.all(8.0),
                //       //   child: Container(
                //       //     decoration: BoxDecoration(
                //       //       color: Colors.white,
                //       //       borderRadius: const BorderRadius.all(
                //       //         Radius.circular(20),
                //       //       ),
                //       //       boxShadow: [
                //       //         BoxShadow(
                //       //           color: Colors.grey.withOpacity(0.5),
                //       //           spreadRadius: 2,
                //       //           blurRadius: 7,
                //       //           offset: const Offset(
                //       //               3, 6), // changes position of shadow
                //       //         ),
                //       //       ],
                //       //     ),
                //       //     // height: MediaQuery.of(context).size.height * 0.35,
                //       //     width: MediaQuery.of(context).size.width * 0.7,
                //       //     child: Padding(
                //       //       padding: const EdgeInsets.all(8.0),
                //       //       child: Column(
                //       //         children: [
                //       //           const Text(
                //       //             'Pay off debt in',
                //       //             style: TextStyle(
                //       //               color: AppColors.mainColor1,
                //       //               fontWeight: FontWeight.bold,
                //       //             ),
                //       //           ),
                //       //           Text(
                //       //             '$months months',
                //       //             // '${calculateDebtLoanDuration(
                //       //             //   totalDebtAmount: double.parse(
                //       //             //       totalDebtAmountController.text),
                //       //             //   minPaymentPerMonth: double.parse(
                //       //             //       minimumPaymentController.text),
                //       //             //   annualInterestRate: double.parse(
                //       //             //       annualInterestRateController.text),
                //       //             // )} months',
                //       //             style: const TextStyle(
                //       //               color: AppColors.mainColor2,
                //       //               fontWeight: FontWeight.bold,
                //       //               fontSize: 28,
                //       //             ),
                //       //           ),
                //       //         ],
                //       //       ),
                //       //     ),
                //       //   ),
                //       // );
                //     } else {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //           content: Text('Please fill all the fields'),
                //         ),
                //       );
                //     }
                //   },
                //   child: Text('Calculate'),
                // ),
                // totalDebtAmountController.text.isNotEmpty &&
                //         minimumPaymentController.text.isNotEmpty &&
                //         annualInterestRateController.text.isNotEmpty
                //     ? Visibility(
                //         visible: isVisible,
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Container(
                //             decoration: BoxDecoration(
                //               color: Colors.white,
                //               borderRadius: const BorderRadius.all(
                //                 Radius.circular(20),
                //               ),
                //               boxShadow: [
                //                 BoxShadow(
                //                   color: Colors.grey.withOpacity(0.5),
                //                   spreadRadius: 2,
                //                   blurRadius: 7,
                //                   offset: const Offset(
                //                       3, 6), // changes position of shadow
                //                 ),
                //               ],
                //             ),
                //             // height: MediaQuery.of(context).size.height * 0.35,
                //             width: MediaQuery.of(context).size.width * 0.7,
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: Column(
                //                 children: [
                //                   const Text(
                //                     'Pay off debt in',
                //                     style: TextStyle(
                //                       color: AppColors.mainColor1,
                //                       fontWeight: FontWeight.bold,
                //                     ),
                //                   ),
                //                   Text(
                //                     // '$months months',
                //                     // '${calculateDebtLoanDuration(
                //                     //   totalDebtAmount: totalDebtAmount,
                //                     //   minPaymentPerMonth: minPaymentPerMonth,
                //                     //   annualInterestRate: annualInterestRate,
                //                     // )} months',
                //                     '${calculateDebtLoanDuration(
                //                       totalDebtAmount: double.parse(
                //                           totalDebtAmountController.text),
                //                       minPaymentPerMonth: double.parse(
                //                           minimumPaymentController.text),
                //                       annualInterestRate: double.parse(
                //                           annualInterestRateController.text),
                //                     )} months',
                //                     style: const TextStyle(
                //                       color: AppColors.mainColor2,
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: 28,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //       )
                //     : const SizedBox(),
                // bool isVisible = false;
              ],
            ),
          ),
          FullWidthButtonWithText(
              text: Strings.addDebt,
              onPressed: isCreateButtonEnabled.value
                  ? () async {
                      _addDebtController(
                        debtNameController,
                        totalDebtAmountController,
                        annualInterestRateController,
                        minimumPaymentController,
                        selectedWallet!,
                        // _selectedRecurrence,
                        ref,
                      );
                    }
                  : null),
        ],
      ),
    );
  }

  void _addDebtController(
    TextEditingController debtNameController,
    TextEditingController totalDebtAmountController,
    TextEditingController annualInterestRateController,
    TextEditingController minimumPaymentController,
    Wallet selectedWallet,
    // String recurring,
    WidgetRef ref,
  ) async {
    final userId = ref.watch(userIdProvider);
    final debtName = debtNameController.text;
    final amount = double.parse(totalDebtAmountController.text);
    final annualInterestRate = double.parse(annualInterestRateController.text);
    final minimumPayment = double.parse(minimumPaymentController.text);
    final monthsToPay = calculateDebtLoanDuration(
        totalDebtAmount: amount,
        minPaymentPerMonth: minimumPayment,
        annualInterestRate: annualInterestRate);
    final lastMonthInterest = getLastMonthInterest(
        totalDebtAmount: amount,
        minPaymentPerMonth: minimumPayment,
        annualInterestRate: annualInterestRate);
    final lastMonthPrinciple = getLastMonthPrinciple(
        totalDebtAmount: amount,
        minPaymentPerMonth: minimumPayment,
        annualInterestRate: annualInterestRate);

    final isCreated = await ref.read(addDebtProvider.notifier).addDebt(
        debtName: debtName,
        totalDebtAmount: amount,
        annualInterestRate: annualInterestRate,
        minimumPayment: minimumPayment,
        // frequency: recurring,
        userId: userId!,
        walletId: selectedWallet.walletId,
        totalNumberOfMonthsToPay: monthsToPay,
        lastMonthPrinciple: lastMonthPrinciple,
        lastMonthInterest: lastMonthInterest);

    if (isCreated && mounted) {
      debtNameController.clear();
      totalDebtAmountController.clear();
      annualInterestRateController.clear();
      minimumPaymentController.clear();
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

  double getLastMonthInterest({
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
    return interest;
  }

  double getLastMonthPrinciple({
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
    return principle;
  }
}
