// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:pocketfi/src/common_widgets/animations/loading_animation_view.dart';
// import 'package:pocketfi/src/common_widgets/animations/small_error_animation_view.dart';
// import 'package:pocketfi/src/features/budget/wallet/application/get_wallet_id_provider.dart';
// import 'package:pocketfi/src/features/budget/wallet/domain/wallet.dart';
// import 'package:pocketfi/src/features/budget/wallet/domain/wallet_id.dart';

// class TestWalletId extends ConsumerWidget {
//   final Wallet wallet;
//   const TestWalletId({
//     super.key,
//     required this.wallet,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final getWalletId = ref.watch(getWalletIdProvider(wallet));
//     return getWalletId.when(
//       data: (walletId) {
//         return Text(walletId.walletId);
//       },
//       loading: () {
//         return const LoadingAnimationView();
//       },
//       error: (error, stackTrace) {
//         return const SmallErrorAnimationView();
//       },
//     );
//   }
// }
