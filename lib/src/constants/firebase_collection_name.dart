import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseCollectionName {
  static const thumbnails = 'thumbnails';
  static const comments = 'comments';
  static const likes = 'likes';
  static const posts = 'posts';
  static const users = 'users';

  static const transactions = 'transactions';
  static const categories = 'categories';
  static const tags = 'tags';
  static const bookmarks = 'bookmarks';

  static const wallets = 'wallets';

  static const budgets = 'budgets';

  const FirebaseCollectionName._(); // private constructor
}
