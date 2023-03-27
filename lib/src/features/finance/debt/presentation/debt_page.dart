// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
// import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
// import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
// import 'package:pocketfi/src/constants/app_colors.dart';
// import 'package:pocketfi/src/features/finance/debt/application/debt_providers.dart';
// import 'package:pocketfi/src/features/finance/debt/presentation/add_debt_view.dart';
// import 'package:pocketfi/src/features/finance/debt/presentation/debt_tiles.dart';

// class DebtPage extends ConsumerWidget {
//   const DebtPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final debts = ref.watch(userDebtsProvider);

//     return
//         // SingleChildScrollView(
//         //   physics: const AlwaysScrollableScrollPhysics(),
//         //   child:
//         Padding(
//       padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
//       child: Column(
//         children: [
//           // Display the percentage
//           Container(
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
//                   offset: const Offset(3, 6), // changes position of shadow
//                 ),
//               ],
//             ),
//             height: MediaQuery.of(context).size.height * 0.35,
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SizedBox(
//                 // width: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       fixedSize:
//                           Size(MediaQuery.of(context).size.width * 0.35, 55),
//                       backgroundColor: AppColors.mainColor2,
//                       foregroundColor: Colors.white,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(30),
//                         ),
//                       ),
//                     ),
//                     onPressed: () {
//                       Navigator.of(context, rootNavigator: true).push(
//                         MaterialPageRoute(
//                           builder: (context) => const AddDebtView(),
//                         ),
//                       );
//                     },
//                     child: const SizedBox(
//                       child: Text(
//                         'Add Debt',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 17,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.1,
//               ),
//               SizedBox(
//                 // width: double.infinity,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       fixedSize:
//                           Size(MediaQuery.of(context).size.width * 0.35, 55),
//                       backgroundColor: AppColors.mainColor1,
//                       foregroundColor: Colors.white,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(30),
//                         ),
//                       ),
//                     ),
//                     onPressed: () {},
//                     child: const SizedBox(
//                       child: Text(
//                         'Track',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 17,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           // Display the list of debts
//           Expanded(
//             child: debts.when(data: (debts) {
//               if (debts.isEmpty) {
//                 return const EmptyContentsWithTextAnimationView(
//                     text: 'No debts yet');
//               }
//               return ListView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: debts.length,
//                 itemBuilder: (context, index) {
//                   final debt = debts.elementAt(index);
//                   return DebtTiles(
//                     debt: debt,
//                   );
//                 },
//               );
//               // return Text('test');
//             }, error: (error, stackTrace) {
//               return const ErrorAnimationView();
//             }, loading: () {
//               return const LoadingAnimationView();
//             }),
//           ),
//           // const DebtTiles(
//           //   debtName: 'PTPTN',
//           // ),
//           // const DebtTiles(
//           //   debtName: 'Car Loan',
//           // ),
//         ],
//       ),
//       // ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/empty_contents_with_text_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/error_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/finance/debt/application/debt_providers.dart';
import 'package:pocketfi/src/features/finance/debt/presentation/add_debt_view.dart';
import 'package:pocketfi/src/features/finance/debt/presentation/debt_details_view.dart';
import 'package:pocketfi/src/features/finance/debt/presentation/debt_tiles.dart';
import 'package:pocketfi/src/features/finance/debt/presentation/debt_overview_view.dart';

class DebtPage extends ConsumerWidget {
  const DebtPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debts = ref.watch(userDebtsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(userDebtsProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
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
                        offset:
                            const Offset(3, 6), // changes position of shadow
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height * 0.35,
                ),
              ),
            ),
            // SliverToBoxAdapter(
            //   child: SizedBox(height: 10),
            // ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.35, 55),
                          backgroundColor: AppColors.mainColor2,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => const AddDebtView(),
                            ),
                          );
                        },
                        child: const SizedBox(
                          child: Text(
                            'Add Debt',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.1,
                  // ),
                  // SizedBox(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         fixedSize: Size(
                  //             MediaQuery.of(context).size.width * 0.35, 55),
                  //         backgroundColor: AppColors.mainColor1,
                  //         foregroundColor: Colors.white,
                  //         shape: const RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.all(
                  //             Radius.circular(30),
                  //           ),
                  //         ),
                  //       ),
                  //       onPressed: () {},
                  //       child: const SizedBox(
                  //         child: Text(
                  //           'Track',
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             fontSize: 17,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            debts.when(
              data: (debts) {
                if (debts.isNotEmpty) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final debt = debts.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: DebtTiles(
                            debt: debt,
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                  builder: (context) => DebtDetailsView(
                                    debt: debt,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: debts.length,
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(
                    child: EmptyContentsWithTextAnimationView(
                      text: 'No debts added yet',
                    ),
                  );
                }
              },
              loading: () => const SliverToBoxAdapter(
                child: LoadingAnimationView(),
              ),
              error: (error, stackTrace) => const SliverToBoxAdapter(
                child: ErrorAnimationView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
