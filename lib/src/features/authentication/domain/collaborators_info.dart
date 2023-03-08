import 'package:flutter/foundation.dart';
import 'package:pocketfi/src/constants/firebase_field_name.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class CollaboratorsInfo {
  final UserId userId;
  final String displayName;
  final String? email;

  const CollaboratorsInfo({
    required this.userId,
    required this.displayName,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      FirebaseFieldName.userId: userId,
      FirebaseFieldName.displayName: displayName,
      FirebaseFieldName.email: email,
    };
  }
}
