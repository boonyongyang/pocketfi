import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';

@immutable
class WalletPayload extends MapView<String, dynamic> {
  WalletPayload({
    required String walletId,
    required String walletName,
    // required double? walletBalance,
    required String userId,
    List<CollaboratorsInfo>? collaborators,
  }) : super({
          FirebaseFieldName.walletId: walletId,
          FirebaseFieldName.walletName: walletName,
          // FirebaseFieldName.walletBalance: walletBalance,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
          FirebaseFieldName.userId: userId,
          FirebaseCollectionName.collaborators:
              collaborators!.map((e) => e.toMap()).toList(),
        });
}
