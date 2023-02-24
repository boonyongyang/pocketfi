import 'package:flutter/material.dart';
import 'package:pocketfi/enums/date_sorting.dart';

@immutable
class RequestForWallets {
  final String walletId;
  final bool sortedByCreatedAt;
  final DateSorting dateSorting;

  const RequestForWallets({
    required this.walletId,
    this.sortedByCreatedAt = true,
    this.dateSorting = DateSorting.newestOnTop,
  });

  @override
  bool operator ==(covariant RequestForWallets other) {
    return walletId == other.walletId &&
        sortedByCreatedAt == other.sortedByCreatedAt &&
        dateSorting == other.dateSorting;
  }

  @override
  int get hashCode => Object.hashAll(
        [
          walletId,
          sortedByCreatedAt,
          dateSorting,
        ],
      );
}
