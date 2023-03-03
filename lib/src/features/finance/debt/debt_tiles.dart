import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';

class DebtTiles extends ConsumerWidget {
  final String debtName;
  const DebtTiles({
    super.key,
    required this.debtName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
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
          children: [
            // Column(
            //   // mainAxisAlignment: MainAxisAlignment.start,
            //   children: const [
            //     Padding(
            //       padding: EdgeInsets.all(8.0),
            //       child: CircleAvatar(
            //         backgroundColor: AppColors.subColor2,
            //         child: FaIcon(
            //           FontAwesomeIcons.moneyCheckDollar,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //     // Expanded(child: SizedBox()),
            //   ],
            // ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.1,
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: AppColors.subColor2,
                            child: FaIcon(
                              FontAwesomeIcons.moneyCheckDollar,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            debtName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit_rounded,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'RM 1500.00 ',
                          style: TextStyle(
                            color: AppColors.mainColor1,
                            fontSize: 16,
                          ),
                        ),
                        Text('/RM 30000.00',
                            style: TextStyle(
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
