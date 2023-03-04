import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';

class SavingGoalsTiles extends ConsumerWidget {
  final String savingGoalsName;
  const SavingGoalsTiles({
    super.key,
    required this.savingGoalsName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
        bottom: 8.0,
      ),
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
                          padding: EdgeInsets.only(
                            right: 8.0,
                            top: 8.0,
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColors.subColor1,
                            child: FaIcon(
                              FontAwesomeIcons.piggyBank,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            savingGoalsName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: AppColors.mainColor1,
                            ),
                          ),
                        ),
                        // const Text(
                        //   'RM 1500.00 ',
                        //   style: TextStyle(
                        //     color: AppColors.mainColor1,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 16,
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            right: 8.0,
                            top: 8.0,
                          ),
                          child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: SizedBox()),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Due',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.mainColor1,
                              ),
                            ),
                            Text(
                              '30/12/2021',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.mainColor1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            right: 8.0,
                            top: 8.0,
                          ),
                          child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: SizedBox()),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                // Text(
                                //   'Saving Goals',
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //     fontSize: 15,
                                //     color: AppColors.mainColor1,
                                //   ),
                                // ),
                                Text(
                                  'RM 150.00',
                                  style: TextStyle(
                                    color: AppColors.mainColor1,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  ' /RM 1500.00',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.mainColor2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
