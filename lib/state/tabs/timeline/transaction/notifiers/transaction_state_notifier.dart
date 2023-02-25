import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionTypeNotifier extends StateNotifier<int> {
  TransactionTypeNotifier() : super(0);

  set index(int value) {
    state = value;
  }

  void setTransactionType(int index) {
    state = index;
  }

  // TransactionType getTransactionType() {
  //   if (index == 0) {
  //     return TransactionType.expense;
  //   } else if (index == 1) {
  //     return TransactionType.income;
  //   } else {
  //     return TransactionType.transfer;
  //   }
  // }
}
