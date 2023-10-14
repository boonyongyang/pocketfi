import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/bills/data/bill_repository.dart';
import 'package:pocketfi/src/features/bills/domain/bill.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';

// * billTabIndexProvider state provider (0 for upcoming tab, 1 for history tab)
final StateProvider<int> billTabIndexProvider = StateProvider<int>((ref) {
  return 0;
});

// * billTabIndexProvider
// final billTabIndexProvider = StateNotifierProvider<BillTabIndexNotifier, int>(
// (ref) => BillTabIndexNotifier());

// * billTabNotifier
// class BillTabIndexNotifier extends StateNotifier<int> {
// BillTabIndexNotifier() : super(0);

// @override
// set state(BillStatus value) => state = value;

// void setBillStatus(int index) => state = BillStatus.values[index];

// void setUnpaid() => state = BillStatus.unpaid;
// void setPaid() => state = BillStatus.paid;
// void setOverdue() => state = BillStatus.overdue;
// }

// returns the list of transactions for the current month
final currentMonthBillsProvider = Provider<List<Bill>>((ref) {
  final billList = ref.watch(userBillsProvider);
  final month = ref.watch(overviewMonthProvider);
  if (billList.hasValue) {
    final bills = billList.value ?? [];
    return bills.where((bill) {
      // if data is empty, then the where function will return an empty list
      return bill.dueDate.month == month.month &&
          bill.dueDate.year == month.year;
    }).toList();
  }
  return [];
});

// returns the list of categories that have transactions in the current month
final filteredBillCategoriesProvider =
    Provider.autoDispose<List<Category>>((ref) {
  final categories = ref.watch(categoriesProvider);
  final currentMonthBills = ref.watch(currentMonthBillsProvider);

  final filteredCategories = categories.where((category) {
    return currentMonthBills.any((tran) {
      return tran.categoryName == category.name;
    });
  }).toList()
    ..sort((a, b) {
      final aTotalAmount =
          getCategoryTotalAmountForCurrentMonth(a.name, currentMonthBills);
      final bTotalAmount =
          getCategoryTotalAmountForCurrentMonth(b.name, currentMonthBills);
      return bTotalAmount.compareTo(aTotalAmount);
    });

  return filteredCategories;
});

// returns the total amount of a specific category
final billCategoryTotalAmountForCurrentMonthProvider =
    Provider.autoDispose.family<double, String>((ref, categoryName) {
  final transactionList = ref.watch(currentMonthBillsProvider);

  final categoryTransactions =
      transactionList.where((tran) => tran.categoryName == categoryName);
  return getTotalAmount(categoryTransactions.toList());
});

// returns the total amount of a specific transaction type
final totalTypeAmountProvider = Provider.autoDispose<double>((ref) {
  final currentMonthTransactions = ref.watch(currentMonthBillsProvider);

  final billsOfType = currentMonthTransactions
      // .where((bill) => bill. == transactionType)
      .toList();
  final totalAmountOfType = getTotalAmount(billsOfType);

  return totalAmountOfType;
});

// to calculate the total amount for a category in the current month
double getCategoryTotalAmountForCurrentMonth(
    String categoryName, List<Bill> bills) {
  final categoryBills =
      bills.where((tran) => tran.categoryName == categoryName);
  return getTotalAmount(categoryBills.toList());
}

double getTotalAmount(List<Bill> bills) {
  return bills.fold<double>(
    0,
    (previousValue, element) => previousValue + element.amount,
  );
}

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
