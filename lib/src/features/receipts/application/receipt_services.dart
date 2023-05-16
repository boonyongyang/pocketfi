import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/features/receipts/domain/receipt.dart';

final receiptProvider = StateNotifierProvider<ReceiptNotifier, Receipt?>(
  (ref) => ReceiptNotifier(),
);

class ReceiptNotifier extends StateNotifier<Receipt?> {
  ReceiptNotifier() : super(null);

  void setReceipt(Receipt receipt) {
    state = receipt;
  }

  void resetReceipt() {
    state = null;
  }

  void updateReceipt(Receipt receipt) {
    state = state?.copyWith(
      amount: receipt.amount,
      date: receipt.date,
      merchant: receipt.merchant,
    );
  }

  void updateAmount(double amount) {
    state = state?.copyWith(amount: amount);
  }

  void updateDate(DateTime date) {
    state = state?.copyWith(date: date);
  }

  void updateMerchant(String merchant) {
    state = state?.copyWith(merchant: merchant);
  }
}
