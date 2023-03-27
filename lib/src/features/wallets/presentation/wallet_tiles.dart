import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';

class WalletTiles extends ConsumerWidget {
  // final Iterable<Wallet> wallet;
  final Wallet wallet;
  final VoidCallback onTap;

  const WalletTiles({
    super.key,
    required this.wallet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final userInfo = ref.watch(userIdProvider);
    // wallet.userId = userInfo.userId;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (wallet.ownerId != wallet.userId)
                      const CircleAvatar(
                        backgroundColor: AppColors.subColor1,
                        child: Icon(
                          AppIcons.wallet,
                          color: Colors.white,
                        ),
                      ),
                    if (wallet.ownerId == wallet.userId)
                      const CircleAvatar(
                        backgroundColor: AppColors.subColor2,
                        child: Icon(
                          AppIcons.wallet,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        top: 8.0,
                        bottom: 2.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            wallet.walletName,
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //     left: 8.0,
                    //     top: 2.0,
                    //     bottom: 8.0,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         'RM ${wallet.walletBalance.toStringAsFixed(2)}',
                    //         style: const TextStyle(
                    //           fontSize: 20,
                    //           fontWeight: FontWeight.bold,
                    //           color: AppColors.mainColor2,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const [
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.mainColor1,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
