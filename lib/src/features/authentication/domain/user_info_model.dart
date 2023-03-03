import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:pocketfi/src/constants/firebase_field_name.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

@immutable
class UserInfoModel extends MapView<String, String?> {
  final UserId userId;
  final String displayName;
  final String? email;

  // this will create a map of the user info and set it to the super map
  UserInfoModel({
    required this.userId,
    required this.displayName,
    required this.email,
  }) : super(
          {
            FirebaseFieldName.userId: userId,
            FirebaseFieldName.displayName: displayName,
            FirebaseFieldName.email: email,
          },
        );

  // this will create a UserInfoModel from a json map
  UserInfoModel.fromJson(
    Map<String, dynamic> json, {
    required UserId userId,
  }) : this(
          userId: userId,
          displayName: json[FirebaseFieldName.displayName] ?? '',
          email: json[FirebaseFieldName.email],
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          displayName == other.displayName &&
          email == other.email;

  @override
  int get hashCode => Object.hashAll(
        [
          userId,
          displayName,
          email,
        ],
      );
}
