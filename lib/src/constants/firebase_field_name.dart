import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseFieldName {
  static const userId = 'uid';
  static const postId = 'post_id';
  static const comment = 'comment';
  static const createdAt = 'created_at';
  static const date = 'date';
  static const displayName = 'display_name';
  static const email = 'email';

  static const transactionId = 'transaction_id';
  static const categoryId = 'category_id';
  static const categoryName = 'category_name';
  static const categoryColor = 'category_color';
  static const categoryIcon = 'category_icon';

  static const walletId = 'wallet_id';
  static const walletName = 'wallet_name';
  static const walletBalance = 'wallet_balance';

  static const budgetId = 'budget_id';
  static const budgetName = 'budget_name';
  static const budgetAmount = 'budget_amount';
  static const usedAmount = 'used_amount';
  static const remainingAmount = 'remaining_amount';

  const FirebaseFieldName._(); // private constructor
}
