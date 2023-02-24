import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/state/constants/firebase_field_name.dart';
import 'package:pocketfi/state/tabs/timeline/posts/typedefs/user_id.dart';

@immutable
class Wallet {
  final String walletId;
  final String walletName;
  final double walletBalance;
  final DateTime createdAt;
  // maybe a list idk
  final UserId userId;
  // final Category category;

  Wallet(Map<String, dynamic> json, {required this.walletId})
      : walletName = json[FirebaseFieldName.walletName],
        walletBalance = json[FirebaseFieldName.walletBalance],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        userId = json[FirebaseFieldName.userId] as UserId;

  @override
  bool operator ==(covariant Wallet other) =>
      runtimeType == other.runtimeType &&
      other.walletId == walletId &&
      other.walletName == walletName &&
      other.walletBalance == walletBalance &&
      other.createdAt == createdAt &&
      other.userId == userId;

  @override
  int get hashCode => Object.hashAll(
        [
          walletId,
          walletName,
          walletBalance,
          createdAt,
          userId,
        ],
      );
}
