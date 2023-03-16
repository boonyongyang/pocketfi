// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/strings.dart';

import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class CollaboratorsInfo {
  final UserId userId;
  final String displayName;
  final String? email;
  final String? status;
  // final CollaborateRequestStatus? status;

  const CollaboratorsInfo({
    required this.userId,
    required this.displayName,
    this.email,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirebaseFieldName.userId: userId,
      FirebaseFieldName.displayName: displayName,
      FirebaseFieldName.email: email,
      FirebaseFieldName.status: status,
    };
  }

  factory CollaboratorsInfo.fromMap(Map<String, dynamic> map) {
    return CollaboratorsInfo(
      userId: map[FirebaseFieldName.userId] as String,
      displayName: map[FirebaseFieldName.displayName] as String,
      email: map[FirebaseFieldName.email] != null
          ? map[FirebaseFieldName.email] as String
          : null,
      status: map[FirebaseFieldName.status] != null
          ? map[FirebaseFieldName.status] as String
          : null,
      // status: map[FirebaseFieldName.status] != null
      //     ? CollaborateRequestStatus.values.firstWhere(
      //         (status) => status.name == map[FirebaseFieldName.status],
      //         orElse: () => CollaborateRequestStatus.pending,
      //       )
      //     : null
      // status: CollaborateRequestStatus.values.firstWhere(
      //   (status) => status.name == map[FirebaseFieldName.status],
      //   orElse: () => CollaborateRequestStatus.pending,
      // ));
    );
  }

  String toJson() => json.encode(toMap());

  factory CollaboratorsInfo.fromJson(String source) =>
      CollaboratorsInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}

// enum CollaborateRequestStatus {
//   pending(
//     status: Strings.pending,
//   ),
//   accepted(
//     status: Strings.accepted,
//   ),
//   rejected(
//     status: Strings.rejected,
//   );

//   final String status;

//   const CollaborateRequestStatus({
//     required this.status,
//   });
// }
enum CollaborateRequestStatus {
  pending,
  accepted,
  rejected,
}
