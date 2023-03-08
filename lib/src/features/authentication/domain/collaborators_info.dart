// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
    return <String, dynamic>{
      'userId': userId,
      'displayName': displayName,
      'email': email,
    };
  }

  factory CollaboratorsInfo.fromMap(Map<String, dynamic> map) {
    return CollaboratorsInfo(
      userId: map[FirebaseFieldName.userId] as String,
      displayName: map[FirebaseFieldName.displayName] as String,
      email: map[FirebaseFieldName.email] != null
          ? map[FirebaseFieldName.email] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CollaboratorsInfo.fromJson(String source) =>
      CollaboratorsInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
