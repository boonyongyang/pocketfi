import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, Timestamp;
import 'package:flutter/material.dart' show Color, immutable;
import 'package:pocketfi/src/constants/app_colors.dart';

enum RecurringPeriod {
  daily,
  weekly,
  monthly,
  yearly,
  never,
}

enum BillStatus {
  unpaid(
    color: Color(AppColors.unpaidColor),
  ),
  paid(
    color: Color(AppColors.paidColor),
  ),
  overdue(
    color: Color(AppColors.overdueColor),
  );

  final Color color;

  const BillStatus({
    required this.color,
  });
}

@immutable
class Bill {
  final String billId;
  final String userId;
  final String walletId;
  final String walletName;
  final double amount;
  final String categoryName;
  // final TransactionType type;
  final DateTime? createdAt;
  final DateTime dueDate;
  final String description;
  final BillStatus status;
  final RecurringPeriod recurringPeriod;

  const Bill({
    required this.billId,
    required this.userId,
    required this.walletId,
    required this.walletName,
    required this.amount,
    required this.categoryName,
    required this.dueDate,
    required this.description,
    this.createdAt,
    this.status = BillStatus.unpaid,
    this.recurringPeriod = RecurringPeriod.never,
  });

  Bill.fromJson({
    required String billId,
    required Map<String, dynamic> json,
  }) : this(
          billId: billId,
          userId: json[BillKey.userId],
          walletId: json[BillKey.walletId],
          walletName: json[BillKey.walletName],
          amount: json[BillKey.amount],
          categoryName: json[BillKey.categoryName],
          dueDate:
              (json[BillKey.dueDate] as Timestamp?)?.toDate() ?? DateTime.now(),
          createdAt: (json[BillKey.createdAt] as Timestamp).toDate(),
          description: json[BillKey.description],
          // status: json[BillKey.isPaid] ?? false,
          status: BillStatus.values.firstWhere(
            (billStatus) => billStatus.name == json[BillKey.status],
            orElse: () => BillStatus.unpaid,
          ),
          recurringPeriod: RecurringPeriod.values.firstWhere(
            (recurringPeriod) =>
                recurringPeriod.name == json[BillKey.recurringPeriod],
            orElse: () => RecurringPeriod.never,
          ),
        );

  Map<String, dynamic> toJson() => {
        BillKey.userId: userId,
        BillKey.walletId: walletId,
        BillKey.walletName: walletName,
        BillKey.amount: amount,
        BillKey.categoryName: categoryName,
        BillKey.createdAt: FieldValue.serverTimestamp(),
        BillKey.dueDate: dueDate,
        BillKey.description: description,
        BillKey.status: status.name,
        BillKey.recurringPeriod: recurringPeriod.name,
      };

  Bill copyWith({
    String? billId,
    String? userId,
    String? walletId,
    String? walletName,
    double? amount,
    String? categoryName,
    DateTime? createdAt,
    DateTime? dueDate,
    String? description,
    BillStatus? status,
    RecurringPeriod? recurringPeriod,
  }) =>
      Bill(
        billId: billId ?? this.billId,
        userId: userId ?? this.userId,
        walletId: walletId ?? this.walletId,
        walletName: walletName ?? this.walletName,
        amount: amount ?? this.amount,
        categoryName: categoryName ?? this.categoryName,
        createdAt: createdAt ?? this.createdAt,
        dueDate: dueDate ?? this.dueDate,
        description: description ?? this.description,
        status: status ?? this.status,
        recurringPeriod: recurringPeriod ?? this.recurringPeriod,
      );
}

@immutable
class BillKey {
  static const String userId = 'uid';
  static const String walletId = 'wallet_id';
  static const String walletName = 'wallet_name';
  static const String amount = 'amount';
  static const String categoryName = 'category_name';
  static const String createdAt = 'created_at';
  static const String dueDate = 'due_date';
  static const String description = 'description';
  static const String status = 'status';
  static const String recurringPeriod = 'recurring_period';
  const BillKey._();
}
