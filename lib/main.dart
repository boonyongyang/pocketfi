import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/is_logged_in_provider.dart';
import 'package:pocketfi/state/providers/is_loading_provider.dart';
import 'package:pocketfi/views/components/loading/loading_screen.dart';
import 'package:pocketfi/views/constants/app_colors.dart';
import 'package:pocketfi/views/login/login_view.dart';
import 'package:pocketfi/views/tabs/bottom_nav_bar_beamer.dart';
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
        primarySwatch: AppColorsForAll.mainMaterialColor1,
        indicatorColor: Colors.white10,
        // textTheme: const TextTheme(
        // TODO: create constants for these please!
        // headline1: TextStyle(color: Colors.deepPurpleAccent),
        // headline2: TextStyle(color: Colors.deepPurpleAccent),
        // bodyText2: TextStyle(color: Colors.deepPurpleAccent),
        // subtitle1: TextStyle(color: Colors.pinkAccent),
        // subtitle2: TextStyle(color: Colors.pinkAccent),
        // bodyText1: TextStyle(color: Colors.pinkAccent),
        // caption: TextStyle(color: Colors.pinkAccent),
        // overline: TextStyle(color: Colors.pinkAccent),
        // button: TextStyle(color: Colors.pinkAccent),
        // headline3: TextStyle(color: Colors.pinkAccent),
        // headline4: TextStyle(color: Colors.pinkAccent),
        // headline5: TextStyle(color: Colors.pinkAccent),
        // headline6: TextStyle(color: Colors.pinkAccent),
        // ),
        // primarySwatch: Colors.orange,
        // indicatorColor: Colors.orange,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        indicatorColor: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: Consumer(
        builder: (context, ref, child) {
          // check if app is loading
          ref.listen<bool>(isLoadingProvider, (_, isLoading) {
            isLoading
                ? LoadingScreen.instance().show(context: context)
                : LoadingScreen.instance().hide();
          });

          // check if user is logged in
          final isLoggedIn = ref.watch(isLoggedInProvider);
          // isLoggedIn.log();
          return isLoggedIn ? const BottomNavBarBeamer() : const LoginView();
        },
      ),
    );
  }
}
