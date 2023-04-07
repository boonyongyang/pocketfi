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
  final bool isCollaborator;
  // final CollaborateRequestStatus? status;

  const CollaboratorsInfo({
    required this.userId,
    required this.displayName,
    this.email,
    this.status,
    this.isCollaborator = true,
  });

  CollaboratorsInfo.fromJson(Map<String, dynamic> json)
      : userId = json[FirebaseFieldName.userId],
        displayName = json[FirebaseFieldName.displayName],
        email = json[FirebaseFieldName.email],
        status = json[FirebaseFieldName.status],
        isCollaborator = json[FirebaseFieldName.isCollaborator];

  Map<String, dynamic> toJson() => {
        FirebaseFieldName.userId: userId,
        FirebaseFieldName.displayName: displayName,
        FirebaseFieldName.email: email,
        FirebaseFieldName.status: status,
        FirebaseFieldName.isCollaborator: isCollaborator,
      };

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     FirebaseFieldName.userId: userId,
  //     FirebaseFieldName.displayName: displayName,
  //     FirebaseFieldName.email: email,
  //     FirebaseFieldName.status: status,
  //     FirebaseFieldName.isCollaborator: isCollaborator,
  //   };
  // }

  // factory CollaboratorsInfo.fromMap(Map<String, dynamic> map) {
  //   return CollaboratorsInfo(
  //     userId: map[FirebaseFieldName.userId] as String,
  //     displayName: map[FirebaseFieldName.displayName] as String,
  //     email: map[FirebaseFieldName.email] != null
  //         ? map[FirebaseFieldName.email] as String
  //         : null,
  //     status: map[FirebaseFieldName.status] != null
  //         ? map[FirebaseFieldName.status] as String
  //         : null,
  //     isCollaborator: map[FirebaseFieldName.isCollaborator] != null
  //         ? map[FirebaseFieldName.isCollaborator] as bool
  //         : true,
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
  // );

  // String toJson() => json.encode(toMap());

  // factory CollaboratorsInfo.fromJson(String source) =>
  //     CollaboratorsInfo.fromMap(json.decode(source) as Map<String, dynamic>);

//copywith
  CollaboratorsInfo copyWith({
    UserId? userId,
    String? displayName,
    String? email,
    String? status,
    bool? isCollaborator,
  }) {
    return CollaboratorsInfo(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      status: status ?? this.status,
      isCollaborator: isCollaborator ?? this.isCollaborator,
    );
  }

  @override
  String toString() {
    return 'CollaboratorsInfo(userId: $userId, displayName: $displayName, email: $email, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CollaboratorsInfo &&
        other.userId == userId &&
        other.displayName == displayName &&
        other.email == email &&
        other.isCollaborator == isCollaborator &&
        other.status == status;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        isCollaborator.hashCode ^
        status.hashCode;
  }
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
