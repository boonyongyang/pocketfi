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
      // categoryName: receipt.categoryName,
      merchant: receipt.merchant,
      // recognizedText: receipt.recognizedText,
    );
  }

  void updateAmount(double amount) {
    state = state?.copyWith(amount: amount);
  }

  void updateDate(DateTime date) {
    state = state?.copyWith(date: date);
  }

  // void updateCategory(String categoryName) {
  //   state = state?.copyWith(categoryName: categoryName);
  // }

  void updateMerchant(String merchant) {
    state = state?.copyWith(merchant: merchant);
  }

  // void updateScannedText(String scannedText) {
  //   state = state?.copyWith(scannedText: scannedText);
  // }

  // void updateImage(String image) {
  //   state = state?.copyWith(image: image);
  // }

  // void updateReceiptFromJson(Map<String, dynamic> json) {
  //   state = Receipt.fromJson(id: state!.id, json: json);
  // }

  // void updateReceiptFromReceipt(Receipt receipt) {
  //   state = receipt;
  // }

  // void updateReceiptFromReceiptId(String receiptId) {
  //   state = state?.copyWith(id: receiptId);
  // }

  // void updateReceiptFromAmount(double amount) {
  //   state = state?.copyWith(amount: amount);
  // }
}
