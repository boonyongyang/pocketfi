import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/bills/data/bill_repository.dart';
import 'package:pocketfi/src/features/bills/domain/bill.dart';

// * billProvider for create, update, and delete bills
final billProvider =
    StateNotifierProvider<BillNotifier, IsLoading>((ref) => BillNotifier());

final selectedBillProvider = StateNotifierProvider<SelectedBillNotifier, Bill?>(
  (_) => SelectedBillNotifier(null),
);

// * selectedBill notifier
class SelectedBillNotifier extends StateNotifier<Bill?> {
  SelectedBillNotifier(Bill? bill) : super(bill);

  void setSelectedBill(Bill bill) => state = bill;

  void resetSelectedBillState() => state = null;

  void updateBillAmount(double newAmount, WidgetRef ref) {
    Bill? bill = ref.watch(selectedBillProvider);
    if (bill != null) {
      bill = bill.copyWith(amount: newAmount);
      state = bill;
    }
  }

  void updateBillCategory(Category newCategory, WidgetRef ref) {
    Bill? bill = ref.watch(selectedBillProvider);
    if (bill != null) {
      bill = bill.copyWith(categoryName: newCategory.name);
      state = bill;
    }
  }

  void updateBillWallet(Wallet newWallet, WidgetRef ref) {
    Bill? bill = ref.watch(selectedBillProvider);
    if (bill != null) {
      bill = bill.copyWith(
        walletId: newWallet.walletId,
        walletName: newWallet.walletName,
      );
      state = bill;
    }
  }

  void updateBillDueDate(DateTime newDate, WidgetRef ref) {
    Bill? bill = ref.watch(selectedBillProvider);
    if (bill != null) {
      bill = bill.copyWith(dueDate: newDate);
      state = bill;
    }
  }

  void updateBillDescription(String newDescription, WidgetRef ref) {
    Bill? bill = ref.watch(selectedBillProvider);
    if (bill != null) {
      bill = bill.copyWith(description: newDescription);
      state = bill;
    }
  }

  void updateBillStatus(BillStatus newStatus, WidgetRef ref) {
    Bill? bill = ref.watch(selectedBillProvider);
    if (bill != null) {
      bill = bill.copyWith(status: newStatus);
      state = bill;
    }
  }

  void updateBillRecurringPeriod(RecurringPeriod newPeriod, WidgetRef ref) {
    Bill? bill = ref.watch(selectedBillProvider);
    if (bill != null) {
      bill = bill.copyWith(recurringPeriod: newPeriod);
      state = bill;
    }
  }
}
