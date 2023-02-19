import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/image_upload/typedefs/is_loading.dart';
import 'package:pocketfi/state/tabs/budget/wallet/notifier/create_new_wallet_notifier.dart';

final createNewWalletProvider =
    StateNotifierProvider<CreateNewWalletNotifier, IsLoading>(
  (ref) => CreateNewWalletNotifier(),
);
