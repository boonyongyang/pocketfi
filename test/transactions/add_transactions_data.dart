import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentReference, FirebaseFirestore;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/firebase_options.dart';
import 'package:pocketfi/src/features/category/data/category_repository.dart';
import 'package:pocketfi/src/features/transactions/domain/transaction.dart';
import 'package:pocketfi/src/features/wallets/data/wallet_repository.dart';
import 'package:pocketfi/src/utils/document_id_from_current_date.dart';

// wrap with ProviderScope to use riverpod
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // TODO: add ur own account details here
  const userId = '6FxxAxJTb1VNpsqdNMZaTNlmgQj1';

  // NO NEED CHANGE ANYTHING BELOW
  final wallet = await getPersonalWalletByUserId(userId);
  final walletId = wallet?.walletId ?? '2023-04-07T10:05:39.813954';
  final walletName = wallet?.walletName ?? 'Personal';

  test('Add fake transactions to Firebase', () async {
    final List<String> activities = [
      'Shopping at mall',
      'Eating at restaurant',
      'shopping online',
      'going to the gym',
      'quitting smoking',
      'going to the movies',
      'going to the beach',
      'having a party',
      'yoga',
      'ice skating',
      'eating ice cream',
      'Buying groceries',
      'Paying bills',
      'Gas for car',
      'Entertainment',
      'Traveling',
      'Gift for someone',
      'Buying clothes',
      'Buying shoes',
      'Buying accessories',
      'Medical expenses',
      'Donation',
      'Salary',
      'Investment',
      'Selling items',
      'Refund',
      'Interest',
      'Other',
    ];
    final random = Random();
    final transactions = List.generate(
      210,
      (index) {
        final bool isExpense = random.nextBool();
        final type =
            isExpense ? TransactionType.expense : TransactionType.income;
        final categoryName = isExpense
            ? expenseCategories[random.nextInt(expenseCategories.length)].name
            : incomeCategories[random.nextInt(incomeCategories.length)].name;

        return Transaction(
          transactionId: documentIdFromCurrentDate(),
          userId: userId,
          walletId: walletId,
          walletName: walletName,
          amount: (random.nextInt(150) + random.nextDouble()),
          type: type,
          description: activities[random.nextInt(activities.length)],
          categoryName: categoryName,
          date: DateTime.now().subtract(Duration(days: random.nextInt(120))),
          transactionImage: null,
          isBookmark: false,
          tags: const [],
        );
      },
    );

    for (final transaction in transactions) {
      final isSuccessful =
          await const TransactionProvider().addNewTransaction(transaction);

      expect(isSuccessful, true);
    }
  });
}

// this goal is to create a list of fake transactions and upload to firebase, using riverpod and the providers we created in the previous step
// a class that will be used to add transactions to firebase
class TransactionProvider extends ConsumerWidget {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  const TransactionProvider({super.key});

  Future<bool> addNewTransaction(Transaction transaction) async {
    try {
      final DocumentReference documentReference = FirebaseFirestore.instance
          .collection('transactions')
          .doc(transaction.transactionId);

      await documentReference.set({
        'uid': transaction.userId,
        'wallet_id': transaction.walletId,
        'wallet_name': transaction.walletName,
        // amount to double with 2 decimal places
        'amount': transaction.amount,
        'categoryName': transaction.categoryName,
        'type': transaction.type.name,
        'date': transaction.date,
        'created_at': transaction.date,
        'is_bookmark': transaction.isBookmark,
        'description': transaction.description,
        'tags': transaction.tags,
        'isFakeData': true,
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    throw Container(color: Colors.amber);
  }
}
