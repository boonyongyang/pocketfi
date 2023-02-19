import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/state/constants/firebase_field_name.dart';

@immutable
class WalletPayload extends MapView<String, dynamic> {
  WalletPayload({
    required String walletName,
    required double? walletBalance,
    required String userId,
  }) : super({
          FirebaseFieldName.walletName: walletName,
          FirebaseFieldName.walletBalance: walletBalance,
          FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
          FirebaseFieldName.userId: userId,
        });
}
