import 'dart:io';

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocketfi/src/common_widgets/buttons/full_width_button_with_text.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/delete_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/wallets/application/wallet_services.dart';
import 'package:pocketfi/src/features/wallets/domain/wallet.dart';
import 'package:pocketfi/src/features/category/application/category_services.dart';
import 'package:pocketfi/src/features/category/domain/category.dart';
import 'package:pocketfi/src/features/category/presentation/category_page.dart';
import 'package:pocketfi/src/features/bills/application/bill_services.dart';
import 'package:pocketfi/src/features/bills/domain/bill.dart';
import 'package:pocketfi/src/features/shared/date_picker/application/date_services.dart';
import 'package:pocketfi/src/features/transactions/presentation/add_new_transactions/category_selector_view.dart';
import 'package:pocketfi/src/features/wallets/presentation/select_wallet_dropdownlist.dart';
import 'package:pocketfi/src/utils/haptic_feedback_service.dart';

class UpdateBillPage extends StatelessWidget {
  const UpdateBillPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const UpdateBillForm();
  }
}

class UpdateBillForm extends StatefulHookConsumerWidget {
  const UpdateBillForm({Key? key}) : super(key: key);

  @override
  UpdateBillFormState createState() => UpdateBillFormState();
}

class UpdateBillFormState extends ConsumerState<UpdateBillForm> {
  String _selectedRecurrence = 'Never';
  String _selectedReminder = 'Never';

  @override
  Widget build(BuildContext context) {
    final selectedBill = ref.watch(selectedBillProvider);
    final categories = ref.watch(expenseCategoriesProvider);
    final selectedCategory =
        getCategoryWithCategoryName(selectedBill?.categoryName);

    final selectedWallet = ref.watch(selectedWalletProvider);

    final amountController =
        useTextEditingController(text: selectedBill?.amount.toString());
    final noteController =
        useTextEditingController(text: selectedBill?.description);
    final isSaveButtonEnabled = useState(false);

    useEffect(
      () {
        void listener() =>
            isSaveButtonEnabled.value = amountController.text.isNotEmpty;
        amountController.addListener(listener);
        return () {
          amountController.removeListener(listener);
        };
      },
      [amountController],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor1,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Edit Bill',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: AppColors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            resetCategoryState(ref);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              color: AppColors.red,
            ),
            onPressed: () async {
              final isConfirmDelete = await const DeleteDialog(
                titleOfObjectToDelete: Strings.bill,
              ).present(context);

              if (isConfirmDelete == null) return;

              if (isConfirmDelete) {
                await ref.read(billProvider.notifier).deleteBill(
                      billId: selectedBill!.billId,
                      userId: selectedBill.userId,
                      walletId: selectedBill.walletId,
                    );
                resetCategoryState(ref);
                if (mounted) {
                  Navigator.of(context).maybePop();
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.only(
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            child: Column(
              children: [
                BillAmountTextField(amountController: amountController),
                const SelectCurrency(),
                // * Select Category and Wallet
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8.0),
                      SelectCategory(
                        categories: categories,
                        selectedCategory: selectedCategory,
                      ),
                      const Spacer(),
                      const Icon(AppIcons.wallet, color: AppColors.mainColor1),
                      const SelectWalletDropdownList(),
                    ],
                  ),
                ),
                // * DatePicker, Note and Recurrence
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const BillDatePicker(),
                      WriteOptionalNote(noteController: noteController),
                      const SizedBox(height: 8.0),
                      selectReccurence(),
                      const SizedBox(height: 8.0),
                      selectReminder(),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SaveButton(
                          isSaveButtonEnabled: isSaveButtonEnabled,
                          noteController: noteController,
                          amountController: amountController,
                          categoryName: selectedCategory,
                          mounted: mounted,
                          dueDate: selectedBill?.dueDate,
                          selectedWallet: selectedWallet,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row selectReccurence() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Recurrence:'),
        DropdownButton(
          items: const [
            DropdownMenuItem(
              value: 'Never',
              child: Text('Never'),
            ),
            DropdownMenuItem(
              value: 'Everyday',
              child: Text('Everyday'),
            ),
            DropdownMenuItem(
              value: 'Every Work Day',
              child: Text('Every Work Day'),
            ),
            DropdownMenuItem(
              value: 'Every Week',
              child: Text('Every Week'),
            ),
            DropdownMenuItem(
              value: 'Every 2 Weeks',
              child: Text('Every 2 Weeks'),
            ),
            DropdownMenuItem(
              value: 'Every Month',
              child: Text('Every Month'),
            ),
            DropdownMenuItem(
              value: 'Every Year',
              child: Text('Every Year'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedRecurrence = value!;
            });
          },
          value: _selectedRecurrence,
        ),
      ],
    );
  }

  Row selectReminder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Reminder:'),
        DropdownButton(
          items: const [
            DropdownMenuItem(
              value: 'Never',
              child: Text('Never'),
            ),
            DropdownMenuItem(
              value: '1 week before',
              child: Text('1 week before'),
            ),
            DropdownMenuItem(
              value: '3 days before',
              child: Text('3 days before'),
            ),
            DropdownMenuItem(
              value: '1 day before',
              child: Text('1 day before'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedReminder = value!;
            });
          },
          value: _selectedReminder,
        ),
      ],
    );
  }
}

class SelectCategory extends ConsumerWidget {
  const SelectCategory({
    super.key,
    required this.categories,
    required this.selectedCategory,
  });

  final List<Category> categories;
  final Category? selectedCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (context) {
        return Center(
          child: GestureDetector(
            child: CategorySelectorView(selectedCategory: selectedCategory),
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                ),
                barrierColor: Colors.black.withOpacity(0.5),
                context: context,
                builder: (context) {
                  return SizedBox(
                    height: 400,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                Strings.selectCategory,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CategoryPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8.0,
                            ),
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(selectedBillProvider.notifier)
                                        .updateBillCategory(
                                            categories[index], ref);
                                    Navigator.of(context).pop();
                                  },
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            categories[index].color,
                                        child: categories[index].icon,
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        categories[index].name,
                                        style: const TextStyle(fontSize: 12.0),
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class SelectCurrency extends StatelessWidget {
  const SelectCurrency({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text('MYR',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.mainColor1,
        ));
  }
}

class BillAmountTextField extends ConsumerWidget {
  const BillAmountTextField({
    Key? key,
    required this.amountController,
  }) : super(key: key);

  final TextEditingController amountController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 250,
      child: AutoSizeTextField(
        autofocus: true,
        textAlign: TextAlign.center,
        enableInteractiveSelection: false,
        showCursor: false,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: Strings.zeroAmount,
        ),
        controller: amountController,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.red,
        ),
      ),
    );
  }
}

class WriteOptionalNote extends StatelessWidget {
  const WriteOptionalNote({
    super.key,
    required TextEditingController noteController,
  }) : _noteController = noteController;

  final TextEditingController _noteController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.mode, color: AppColors.mainColor1),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 250,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a note',
              ),
              controller: _noteController,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
          ),
        ),
      ],
    );
  }
}

class SaveButton extends ConsumerWidget {
  const SaveButton({
    super.key,
    required this.isSaveButtonEnabled,
    required this.noteController,
    required this.amountController,
    required this.categoryName,
    required this.selectedWallet,
    required this.mounted,
    required this.dueDate,
    this.billStatus = BillStatus.unpaid,
    this.recurringPeriod = RecurringPeriod.never,
  });

  final ValueNotifier<bool> isSaveButtonEnabled;
  final TextEditingController noteController;
  final TextEditingController amountController;
  final Category? categoryName;
  final Wallet? selectedWallet;
  final DateTime? dueDate;
  final bool mounted;
  final BillStatus billStatus;
  final RecurringPeriod recurringPeriod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FullWidthButtonWithText(
      padding: 0,
      text: Strings.save,
      backgroundColor: AppColors.mainColor2,
      onPressed: isSaveButtonEnabled.value
          ? () async {
              final userId = ref.read(userIdProvider);
              if (userId == null) {
                return;
              }
              final note = noteController.text;
              final amount = amountController.text;
              final bill = ref.read(selectedBillProvider);
              final isCreated =
                  await ref.read(billProvider.notifier).updateBill(
                        billId: bill!.billId,
                        userId: userId,
                        walletId: selectedWallet!.walletId,
                        walletName: selectedWallet!.walletName,
                        billAmount: double.parse(amount),
                        billDueDate: bill.dueDate,
                        categoryName: categoryName!.name,
                        billNote: note,
                        recurringPeriod: recurringPeriod,
                      );
              debugPrint('isCreated is: $isCreated');

              if (isCreated && mounted) {
                noteController.clear();
                amountController.clear();
                Navigator.of(context).pop();

                resetCategoryState(ref);

                ref
                    .read(transactionDateProvider.notifier)
                    .setDate(DateTime.now());

                Fluttertoast.showToast(
                  msg: "Bill updated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Colors.white,
                  textColor: AppColors.mainColor1,
                  fontSize: 16.0,
                );
              }
            }
          : null,
    );
  }
}

class BillDatePicker extends ConsumerStatefulWidget {
  const BillDatePicker({super.key});

  @override
  BillDatePickerState createState() => BillDatePickerState();
}

class BillDatePickerState extends ConsumerState<BillDatePicker> {
  // * select date using date picker
  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return Container(
            height: 300,
            color: AppColors.white,
            child: CupertinoDatePicker(
              initialDateTime: initialDate,
              minimumDate: DateTime(1990),
              maximumDate: DateTime.now().add(const Duration(days: 365)),
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newDate) {
                HapticFeedbackService.mediumImpact();
                setOrUpdateDate(newDate);
              },
            ),
          );
        },
      );
    } else {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1990),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (pickedDate != null) {
        HapticFeedbackService.mediumImpact();
        setOrUpdateDate(pickedDate);
        // TODO: if selectedDate is in the future, make it a scheduled transaction
      }
    }
  }

  void _previousDay(DateTime selectedDate) {
    HapticFeedbackService.lightImpact();
    final newDate = selectedDate.subtract(const Duration(days: 1));
    setOrUpdateDate(newDate);
  }

  void _nextDay(DateTime selectedDate) {
    HapticFeedbackService.lightImpact();
    final newDate = selectedDate.add(const Duration(days: 1));
    setOrUpdateDate(newDate);
  }

  // * setOrUpdateDate
  void setOrUpdateDate(DateTime newDate) => isSelectedBillNull
      ? ref.read(transactionDateProvider.notifier).setDate(newDate)
      : ref.read(selectedBillProvider.notifier).updateBillDueDate(newDate, ref);

  // * get SelectedDate
  DateTime getDate() =>
      ref.watch(selectedBillProvider)?.dueDate ??
      ref.watch(transactionDateProvider);

  String get _selectedDateText {
    final DateTime selectedDate = getDate();

    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day) {
      return Strings.today;
    } else if (selectedDate.year == yesterday.year &&
        selectedDate.month == yesterday.month &&
        selectedDate.day == yesterday.day) {
      return Strings.yesterday;
    } else if (selectedDate.year == tomorrow.year &&
        selectedDate.month == tomorrow.month &&
        selectedDate.day == tomorrow.day) {
      return Strings.tomorrow;
    } else {
      return DateFormat('EEE, d MMM').format(selectedDate);
    }
  }

  bool get isSelectedBillNull =>
      (ref.watch(selectedBillProvider)?.dueDate == null);

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = getDate();

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12.0,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.edit_calendar_rounded,
            color: AppColors.mainColor1,
          ),
          const SizedBox(width: 2.0),
          TextButton(
            onPressed: () => _selectDate(context, selectedDate),
            child: Text(
              _selectedDateText,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              _previousDay(selectedDate);
            },
            icon: const Icon(Icons.arrow_back_ios_rounded),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            onPressed: () {
              _nextDay(selectedDate);
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}
