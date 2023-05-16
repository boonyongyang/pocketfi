import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocketfi/src/constants/firebase_names.dart';
import 'package:pocketfi/src/constants/typedefs.dart';
import 'package:pocketfi/src/features/authentication/domain/collaborators_info.dart';

// ignore: must_be_immutable
class SharedWallet {
  final String walletId;
  final String walletName;
  final UserId userId;
  final DateTime? createdAt;
  final UserId ownerId;
  final String ownerName;
  final String ownerEmail;
  List<CollaboratorsInfo>? collaborators;

  SharedWallet({
    required this.walletId,
    required this.walletName,
    required this.userId,
    this.createdAt,
    required this.ownerId,
    required this.ownerName,
    required this.ownerEmail,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      FirebaseFieldName.walletId: walletId,
      FirebaseFieldName.walletName: walletName,
      FirebaseFieldName.userId: userId,
      FirebaseFieldName.createdAt: createdAt,
      FirebaseFieldName.ownerId: ownerId,
      FirebaseFieldName.ownerName: ownerName,
      FirebaseFieldName.ownerEmail: ownerEmail,
    };
  }

  SharedWallet.fromJson({
    required Map<String, dynamic> map,
  }) : this(
          walletId: map[FirebaseFieldName.walletId] as String,
          walletName: map[FirebaseFieldName.walletName] as String,
          userId: map[FirebaseFieldName.userId] as UserId,
          createdAt: (map[FirebaseFieldName.createdAt] as Timestamp).toDate(),
          ownerId: map[FirebaseFieldName.ownerId] as UserId,
          ownerName: map[FirebaseFieldName.ownerName] as String,
          ownerEmail: map[FirebaseFieldName.ownerEmail] as String,
        );
}
