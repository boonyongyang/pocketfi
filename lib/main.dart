import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/auth_state_provider.dart';
import 'package:pocketfi/state/auth/providers/is_logged_in_provider.dart';
import 'package:pocketfi/state/providers/is_loading_provider.dart';
import 'package:pocketfi/views/components/loading/loading_screen.dart';
import 'firebase_options.dart';

import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        indicatorColor: Colors.orange,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        indicatorColor: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (context, ref, child) {
          // take care of displaying the loading screen
          ref.listen<bool>(isLoadingProvider, (_, isLoading) {
            isLoading
                ? LoadingScreen.instance().show(context: context)
                : LoadingScreen.instance().hide();
          });
          final isLoggedIn = ref.watch(isLoggedInProvider);
          // isLoggedIn.log();
          return isLoggedIn ? const MainView() : const LoginView();
        },
      ),
    );
  }
}

// for view that is already logged in
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main View'),
      ),
      body: Consumer(
        builder: (_, ref, child) {
          return TextButton(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logOut();
            },
            child: const Text(
              'Logout',
            ),
          );
        },
      ),
    );
  }
}

// for view that is not logged in
class LoginView extends ConsumerWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login View'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
            child: const Text(
              'Sign In with Google',
            ),
          ),
          // TextButton(
          //   onPressed: ref.read(authStateProvider.notifier).loginWithFacebook,
          //   child: const Text(
          //     'Sign In with Facebook',
          //   ),
          // ),
        ],
      ),
    );
  }
}
