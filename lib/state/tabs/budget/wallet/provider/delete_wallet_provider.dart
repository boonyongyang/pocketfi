import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/image_upload/typedefs/is_loading.dart';
import 'package:pocketfi/state/tabs/budget/wallet/notifier/delete_wallet_notifier.dart';

final deleteWalletProvider =
    StateNotifierProvider<DeleteWalletStateNotifier, IsLoading>(
  (_) => DeleteWalletStateNotifier(),
);
