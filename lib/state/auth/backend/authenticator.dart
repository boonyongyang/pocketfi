// core of the authentication system

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pocketfi/state/auth/models/auth_result.dart';

import '../../tabs/timeline/posts/typedefs/user_id.dart';
import '../constants/constants.dart';

class Authenticator {
  const Authenticator();

  /// User? get currentUser => FirebaseAuth.instance.currentUser;
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;

  /// is false if userId is null
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // await FacebookAuth.instance.logOut();
  }

  // Future<void> signInAnonymously() async {
  //   await FirebaseAuth.instance.signInAnonymously();
  // }

  // Future<AuthResult> loginWithFacebook() async {
  //   final loginResult = await FacebookAuth.instance.login();
  //   final token = loginResult.accessToken?.token;
  //   if (token == null) {
  //     // user has aborted login process
  //     return AuthResult.aborted;
  //   }
  //   final oauthCredentials = FacebookAuthProvider.credential(token);

  //   try {
  //     await FirebaseAuth.instance.signInWithCredential(
  //       oauthCredentials,
  //     );
  //     return AuthResult.success;
  //   } on FirebaseAuthException catch (e) {
  //     final email = e.email;
  //     final credential = e.credential;
  //     if (e.code == Constants.accountExistsWithDifferentCredential &&
  //         email != null &&
  //         credential != null) {
  //       // is signing in with facebook, but the email is already in use
  //       final providers =
  //           await FirebaseAuth.instance.fetchSignInMethodsForEmail(
  //         email,
  //       );
  //       if (providers.contains(Constants.googleCom)) {
  //         await loginWithGoogle();
  //         FirebaseAuth.instance.currentUser?.linkWithCredential(
  //           credential,
  //         );
  //       }
  //       return AuthResult.success;
  //     }
  //     return AuthResult.failure;
  //   }
  // }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        Constants.emailScope,
      ],
    );

    final signInAccount = await googleSignIn.signIn();

    if (signInAccount == null) {
      return AuthResult.aborted;
    }
    final googleAuth = await signInAccount.authentication;
    final oauthCredentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }
}

  // Authenticator._();
  // static final Authenticator _instance = Authenticator._();
  // static Authenticator get instance => _instance;
  // Future<void> signIn() async {}
