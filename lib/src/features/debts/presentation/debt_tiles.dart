import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/category/data/category_repository.dart';
import 'package:pocketfi/src/features/debts/data/debt_payment_repository.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';

class DebtTiles extends ConsumerWidget {
  final Debt debt;
  final VoidCallback onTap;
  final Color? circleAvatarColor;
  const DebtTiles({
    super.key,
    required this.debt,
    required this.onTap,
    required this.circleAvatarColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet =
        ref.watch(getWalletFromWalletIdProvider(debt.walletId)).value;
    if (wallet == null) {
      return Container();
    }
    var totalAmountPaid = 0.0;
    final debtPaymentsList = ref.watch(userDebtPaymentsProvider).value;
    if (debtPaymentsList != null) {
      for (var debtPayment in debtPaymentsList) {
        if (debtPayment.debtId == debt.debtId) {
          totalAmountPaid +=
              debtPayment.principleAmount + debtPayment.interestAmount;
        }
      }
    }
    final totalDebtPercentage = totalAmountPaid / debt.calculateTotalPayment();

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                offset: const Offset(3, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 8.0,
                ),
                child: CircleAvatar(
                  backgroundColor: circleAvatarColor,
                  child: const FaIcon(
                    FontAwesomeIcons.moneyCheckDollar,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0,
                    left: 8.0,
                    top: 8.0,
                    bottom: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              debt.debtName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.wallet,
                            color: Colors.grey[600],
                            size: 14,
                          ),
                          Text(
                            ' ${wallet.walletName}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: LinearProgressIndicator(
                              minHeight: 25,
                              value: totalDebtPercentage,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorList[
                                    debt.debtAmount.toInt() % colorList.length],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              top: 4.0,
                              bottom: 4.0,
                            ),
                            child: Text(
                                '${(totalDebtPercentage * 100).toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: totalDebtPercentage * 100 > 16
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'MYR ${totalAmountPaid.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.mainColor1,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                              ' / MYR ${debt.calculateTotalPayment().toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainColor2,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
