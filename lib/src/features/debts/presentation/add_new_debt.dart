// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/wallets/presentation/select_wallet_dropdownlist.dart';
import 'package:pocketfi/src/features/debts/application/debt_services.dart';

class AddNewDebt extends StatefulHookConsumerWidget {
  const AddNewDebt({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddDebtViewState();
}

class _AddDebtViewState extends ConsumerState<AddNewDebt> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    final debtNameController = useTextEditingController();
    final totalDebtAmountController = useTextEditingController();
    final annualInterestRateController = useTextEditingController();
    final minimumPaymentController = useTextEditingController();
    final isCreateButtonEnabled = useState(false);
    final selectedWallet = ref.watch(selectedWalletProvider);

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
        centerTitle: true,
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
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 32.0),
                      child: SizedBox(
                        width: 5,
                        child: Icon(
                          AppIcons.wallet,
                          color: AppColors.mainColor1,
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 8.0,
                          right: 16.0,
                          bottom: 8.0,
                        ),
                        child: SelectWalletDropdownList()),
                  ],
                ),
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
    final isCreated = await ref.read(debtProvider.notifier).addNewDebt(
        debtName: debtName,
        totalDebtAmount: amount,
        annualInterestRate: annualInterestRate,
        minimumPayment: minimumPayment,
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
    double endBalance = totalDebtAmount;
    double monthlyInterestRate = (annualInterestRate / 100) / 12;
    double interest = 0;
    double principle = 0;
    int months = 0;

    while (endBalance > 0 && endBalance > minPaymentPerMonth) {
      interest = endBalance * monthlyInterestRate;
      endBalance = endBalance + interest - minPaymentPerMonth;
      principle = minPaymentPerMonth - interest;
      months++;
    }
    interest = endBalance * monthlyInterestRate;
    principle = endBalance;
    endBalance = 0.00;
    months++;
    return months;
  }

  double getLastMonthInterest({
    required double totalDebtAmount,
    required double minPaymentPerMonth,
    required double annualInterestRate,
  }) {
    double endBalance = totalDebtAmount;
    double monthlyInterestRate = (annualInterestRate / 100) / 12;
    double interest = 0;
    double principle = 0;
    int months = 0;

    while (endBalance > 0 && endBalance > minPaymentPerMonth) {
      interest = endBalance * monthlyInterestRate;
      endBalance = endBalance + interest - minPaymentPerMonth;
      principle = minPaymentPerMonth - interest;
      months++;
    }
    interest = endBalance * monthlyInterestRate;
    principle = endBalance;
    endBalance = 0.00;
    months++;
    return interest;
  }

  double getLastMonthPrinciple({
    required double totalDebtAmount,
    required double minPaymentPerMonth,
    required double annualInterestRate,
  }) {
    double endBalance = totalDebtAmount;
    double monthlyInterestRate = (annualInterestRate / 100) / 12;
    double interest = 0;
    double principle = 0;
    int months = 0;

    while (endBalance > 0 && endBalance > minPaymentPerMonth) {
      interest = endBalance * monthlyInterestRate;

      endBalance = endBalance + interest - minPaymentPerMonth;
      principle = minPaymentPerMonth - interest;
      months++;
    }
    interest = endBalance * monthlyInterestRate;
    principle = endBalance;
    endBalance = 0.00;
    months++;
    return principle;
  }
}
