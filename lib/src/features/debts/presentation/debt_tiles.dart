import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/debts/data/debt_payment_repository.dart';
import 'package:pocketfi/src/features/debts/domain/debt.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';

class DebtTiles extends ConsumerWidget {
  final Debt debt;
  final VoidCallback onTap;
  const DebtTiles({
    super.key,
    required this.debt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet =
        ref.watch(getWalletFromWalletIdProvider(debt.walletId)).value;
    if (wallet == null) {
      return Container();
    }
    var totalAmountPaid = 0.0;
    // var totalInterestPaid = 0.0;

    final debtPaymentsList = ref.watch(userDebtPaymentsProvider).value;
    if (debtPaymentsList != null) {
      for (var debtPayment in debtPaymentsList) {
        totalAmountPaid +=
            debtPayment.principleAmount + debtPayment.interestAmount;
        // totalInterestPaid += debtPayment.interestAmount;
      }
    }

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
                offset: const Offset(3, 6), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 8.0,
                ),
                child: CircleAvatar(
                  backgroundColor: AppColors.subColor2,
                  child: FaIcon(
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
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const Padding(
                          //   padding: EdgeInsets.all(8.0),
                          //   child: CircleAvatar(
                          //     backgroundColor: AppColors.subColor2,
                          //     child: FaIcon(
                          //       FontAwesomeIcons.moneyCheckDollar,
                          //       color: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: Text(
                              debt.debtName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          // IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(
                          //     Icons.edit_rounded,
                          //   ),
                          // ),
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
                        height: MediaQuery.of(context).size.height * 0.05,
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
                      // Row(
                      //   children: [
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: const [
                      //         Text(
                      //           'Balance',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         Text('RM 30000.00'),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         Text(
                      //           'Monthly Payment',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         Text('RM 1550.00'),
                      //       ],
                      //     ),
                      //     SizedBox(
                      //       width: MediaQuery.of(context).size.width * 0.05,
                      //     ),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: const [
                      //         Text(
                      //           'PayOff Date',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         Text('28 Jun 2026'),
                      //         SizedBox(
                      //           height: 10,
                      //         ),
                      //         Text(
                      //           'APR',
                      //           style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         Text('4%'),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(right: 8.0),
              //   child: Column(
              //     // mainAxisAlignment: MainAxisAlignment.start,
              //     // crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       IconButton(
              //           onPressed: () {},
              //           icon: const Icon(
              //             Icons.edit_rounded,
              //           ))
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

// Row(
//   children: [
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text(
//           'Balance',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text('RM 30000.00'),
//       ],
//     ),
//     SizedBox(
//       width: MediaQuery.of(context).size.width * 0.15,
//     ),
//     Column(
//       children: const [
//         Text(
//           'PayOff Date',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text('28 Jun 2026'),
//       ],
//     )
//   ],
// ),
// SizedBox(
//   height: MediaQuery.of(context).size.height * 0.015,
// ),
// Row(
//   children: [
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         Text(
//           'Monthly Payment',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text('RM 1550.00'),
//       ],
//     ),
//     SizedBox(
//       width: MediaQuery.of(context).size.width * 0.15,
//     ),
//     Column(
//       children: const [
//         Text(
//           'APR',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text('4%'),
//       ],
//     )
//   ],
// ),
