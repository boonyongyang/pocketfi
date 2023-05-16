import 'package:flutter/foundation.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';

import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class CollaboratorsInfo {
  final UserId userId;
  final String displayName;
  final String? email;
  final String? status;
  final bool isCollaborator;

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

enum CollaborateRequestStatus {
  pending,
  accepted,
  rejected,
}
