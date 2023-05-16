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
  static const collaborators = 'collaborators';
  static const status = 'request_status';
  static const isCollaborator = 'is_collaborator';

  static const ownerId = 'owner_id';
  static const ownerName = 'owner_name';
  static const ownerEmail = 'owner_email';

  static const budgetId = 'budget_id';
  static const budgetName = 'budget_name';
  static const budgetAmount = 'budget_amount';
  static const usedAmount = 'used_amount';
  static const remainingAmount = 'remaining_amount';

  static const debtId = 'debt_id';
  static const debtName = 'debt_name';
  static const debtAmount = 'debt_amount';
  static const minimumPayment = 'minimum_payment';
  static const recurringDateToPay = 'recurring_date_to_pay';
  static const annualInterestRate = 'annual_interest_rate';
  static const frequency = 'frequency';
  static const totalNumberOfMonthsToPay = 'total_number_of_months_to_pay';
  static const lastMonthInterest = 'last_month_interest';
  static const lastMonthPrinciple = 'last_month_principle';

  static const debtPaymentId = 'debt_payment_id';
  static const interestAmount = 'interest_amount';
  static const principleAmount = 'principle_amount';
  static const newBalance = 'new_balance';
  static const previousBalance = 'previous_balance';
  static const isPaid = 'is_paid';
  static const paymentDate = 'payment_date';
  static const paidMonth = 'minimum_pay';

  static const savingGoalId = 'saving_goal_id';
  static const savingGoalName = 'saving_goal_name';
  static const savingGoalAmount = 'saving_goal_amount';
  static const savingGoalDueDate = 'saving_goal_due_date';
  static const savingGoalCurrentAmount = 'saving_goal_current_amount';
  static const savingGoalStartDate = 'saving_goal_start_date';

  static const savingGoalHistoryId = 'saving_goal_history_id';
  static const savingGoalSavedAmount = 'saving_goal_saved_amount';
  static const savingGoalEnterDate = 'saving_goal_saved_date';
  static const savingGoalStatus = 'saving_goal_status';

  const FirebaseFieldName._();
}

@immutable
class FirebaseCollectionName {
  static const thumbnails = 'thumbnails';
  static const comments = 'comments';
  static const likes = 'likes';
  static const posts = 'posts';
  static const users = 'users';

  static const transactions = 'transactions';
  static const categories = 'categories';
  static const tags = 'tags';
  static const bookmarks = 'bookmarks';

  static const bills = 'bills';

  static const wallets = 'wallets';
  static const collaborators = 'collaborators';
  static const sharedWallets = 'shared_wallet';

  static const budgets = 'budgets';

  static const debts = 'debts';
  static const debtPayments = 'debt_payments';

  static const savingGoals = 'saving_goals';
  static const savingGoalsHistory = 'saving_goals_history';

  const FirebaseCollectionName._();
}
