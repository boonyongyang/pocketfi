import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pocketfi/firebase_options.dart';

// loop through firebase transactions collection,
// check if the boolean isFakeData not null and is true,
// then delete the transaction

Future<void> deleteFakeTransactions() async {
  final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection('transactions')
          .where('isFakeData', isEqualTo: true)
          .get();

  for (final QueryDocumentSnapshot<Map<String, dynamic>> document
      in querySnapshot.docs) {
    await document.reference.delete();
  }
}

// main function to run the script
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await deleteFakeTransactions();
}
