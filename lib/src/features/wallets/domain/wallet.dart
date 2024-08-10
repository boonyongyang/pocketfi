// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';

@immutable
class Wallet {
  final String walletId;
  final String walletName;
  // final double walletBalance;
  final DateTime? createdAt;
  final UserId userId;
  final UserId? ownerId;
  final String? ownerName;
  final String? ownerEmail;
  final List<CollaboratorsInfo>? collaborators;
  // TODO add final Category category;`

  const Wallet({
    required this.walletId,
    required this.walletName,
    // required this.walletBalance,
    this.createdAt,
    required this.userId,
    this.ownerId,
    this.ownerName,
    this.ownerEmail,
    this.collaborators,
  });

  Wallet.fromJson(Map<String, dynamic> json)
      : walletId = json[FirebaseFieldName.walletId],
        walletName = json[FirebaseFieldName.walletName],
        // walletBalance = json[FirebaseFieldName.walletBalance],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        userId = json[FirebaseFieldName.userId] as UserId,
        ownerId = json[FirebaseFieldName.ownerId] as UserId,
        ownerName = json[FirebaseFieldName.ownerName] as String,
        ownerEmail = json[FirebaseFieldName.ownerEmail] as String,
        collaborators = json[FirebaseFieldName.collaborators] != null
            ? List<CollaboratorsInfo>.from(
                (json[FirebaseFieldName.collaborators] as List<dynamic>)
                    .map<CollaboratorsInfo?>(
                  (x) => CollaboratorsInfo.fromJson(x as Map<String, dynamic>),
                ),
              )
            : null;

  Map<String, dynamic> toJson() => {
        FirebaseFieldName.walletId: walletId,
        FirebaseFieldName.walletName: walletName,
        // FirebaseFieldName.walletBalance: walletBalance,
        FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
        FirebaseFieldName.userId: userId,
        FirebaseFieldName.ownerId: ownerId,
        FirebaseFieldName.ownerName: ownerName,
        FirebaseFieldName.ownerEmail: ownerEmail,
        FirebaseFieldName.collaborators: collaborators,
      };
  // Wallet(Map<String, dynamic> json, {required this.walletId})
  //     : walletName = json[FirebaseFieldName.walletName],
  //       walletBalance = json[FirebaseFieldName.walletBalance],
  //       createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
  //       userId = json[FirebaseFieldName.userId] as UserId;

  Wallet copyWith({
    String? walletId,
    String? walletName,
    // double? walletBalance,
    DateTime? createdAt,
    UserId? userId,
    UserId? ownerId,
    String? ownerName,
    String? ownerEmail,
    List<CollaboratorsInfo>? collaborators,
  }) {
    return Wallet(
      walletId: walletId ?? this.walletId,
      walletName: walletName ?? this.walletName,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      collaborators: collaborators ?? this.collaborators,
    );
  }

// * DO NOT REMOVE. This is used in WalletDropDownList to compare two wallets
  @override
  bool operator ==(covariant Wallet other) =>
      runtimeType == other.runtimeType &&
      other.walletId == walletId &&
      other.walletName == walletName &&
      // other.walletBalance == walletBalance &&
      other.createdAt == createdAt &&
      // other.collaborators == collaborators &&
      other.ownerId == ownerId &&
      other.ownerName == ownerName &&
      other.ownerEmail == ownerEmail &&
      other.userId == userId;

  @override
  int get hashCode => Object.hashAll(
        [
          walletId,
          walletName,
          // walletBalance,
          ownerId,
          ownerName,
          ownerEmail,
          createdAt,
          userId,
        ],
      );
}
