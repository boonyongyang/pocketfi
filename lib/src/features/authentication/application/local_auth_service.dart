import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_android/local_auth_android.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_ios/local_auth_ios.dart';

class LocalAuth {
  static final _auth = LocalAuthentication();
  static Future<bool> _canAuthenticate() async =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await _canAuthenticate()) return false;

      return await _auth.authenticate(
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Sign in',
            cancelButton: 'No Thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No Thanks',
          ),
        ],
        localizedReason: 'Please authenticate to continue',
        options: const AuthenticationOptions(
          // biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } on Exception catch (e) {
      debugPrint('error $e');
      return false;
    }
  }
}
