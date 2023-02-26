import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart' show Icons;

@immutable
class AppIcons {
  // * timeline

  // transaction
  static const expenseIcon = Icons.arrow_downward;
  static const incomeIcon = Icons.arrow_upward;
  static const transferIcon = Icons.compare_arrows;

  // * budget

  // wallet
  static const wallet = Icons.wallet;

  const AppIcons._();
}
