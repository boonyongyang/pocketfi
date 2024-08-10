import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'firebase_options.dart';
import 'package:pocketfi/src/common_widgets/loading/loading_screen.dart';
import 'package:pocketfi/src/features/authentication/application/is_logged_in_provider.dart';
import 'package:pocketfi/src/features/authentication/presentation/login/login_view.dart';
import 'package:pocketfi/src/features/shared/is_loading_provider.dart';
import 'package:pocketfi/src/routing/bottom_nav_bar_beamer.dart';

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
      // title: 'Home Page',
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        primarySwatch: AppColors.mainMaterialColor1,
        indicatorColor: Colors.white10,
      ),
      debugShowCheckedModeBanner: false,
      // home: const LocalAuthScreen(),
      // * comment this Consumer to try local authentication
      home: Consumer(
        builder: (context, ref, child) {
          ref.listen<bool>(
            isLoadingProvider,
            (_, isLoading) {
              isLoading
                  ? LoadingScreen.instance().show(context: context)
                  : LoadingScreen.instance().hide();
            },
          );
          final isLoggedIn = ref.watch(isLoggedInProvider);
          return isLoggedIn ? const BottomNavBarBeamer() : const LoginView();
        },
      ),
      // * comment this Consumer to try local authentication
    );
  }
}
