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
import 'package:pocketfi/src/features/debts/application/debt_services.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';

class UpdateDebt extends StatefulHookConsumerWidget {
  final Debt debt;
  const UpdateDebt({
    super.key,
    required this.debt,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdateDebtViewState();
}

class _UpdateDebtViewState extends ConsumerState<UpdateDebt> {
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
        centerTitle: true,
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
    WidgetRef ref,
  ) async {
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
    double endBalance = totalDebtAmount;
    double monthlyInterestRate = (annualInterestRate / 100) / 12;
    double interest = 0;
    // ignore: unused_local_variable
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
}
