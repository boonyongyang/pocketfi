import 'package:flutter/foundation.dart';

@immutable
class Constants {
  static const accountExistsWithDifferentCredential =
      'account-exists-with-different-credential';
  static const googleCom = 'google.com';
  static const emailScope = 'email';
  const Constants._(); // private constructor, can't be instantiated outside
}
