// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';

class TempUsers extends MapView<String, dynamic> {
  final UserId userId;
  final String displayName;
  final String? email;
  bool isChecked;

  // this will create a map of the user info and set it to the super map
  TempUsers({
    required this.userId,
    required this.displayName,
    required this.email,
    this.isChecked = false,
  }) : super(
          {
            FirebaseFieldName.userId: userId,
            FirebaseFieldName.displayName: displayName,
            FirebaseFieldName.email: email,
            'isChecked': isChecked,
          },
        );

  // this will create a TempUsers from a json map
  TempUsers.fromJson(
    Map<String, dynamic> json, {
    required UserId userId,
  }) : this(
            userId: userId,
            displayName: json[FirebaseFieldName.displayName] ?? '',
            email: json[FirebaseFieldName.email],
            isChecked: json['isChecked']);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TempUsers &&
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
