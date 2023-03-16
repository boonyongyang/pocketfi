import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/loading/loading_screen.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/features/authentication/application/is_logged_in_provider.dart';
import 'package:pocketfi/src/features/authentication/application/local_auth_service.dart';
import 'package:pocketfi/src/features/authentication/presentation/login/login_view.dart';
import 'package:pocketfi/src/features/shared/is_loading_provider.dart';
import 'package:pocketfi/src/routing/bottom_nav_bar_beamer.dart';

class LocalAuthScreen extends StatefulWidget {
  const LocalAuthScreen({Key? key}) : super(key: key);

  @override
  LocalAuthScreenState createState() => LocalAuthScreenState();
}

class LocalAuthScreenState extends State<LocalAuthScreen> {
  bool authenticated = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalAuth.authenticate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          authenticated = true;
          return authenticated
              ? Consumer(
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
                    return isLoggedIn
                        ? const BottomNavBarBeamer()
                        : const LoginView();
                  },
                )
              : const SizedBox.shrink();
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Authentication failed.'),
                  ElevatedButton(
                    onPressed: () async {
                      authenticated = await LocalAuth.authenticate();
                      if (authenticated) {
                        Fluttertoast.showToast(
                          msg: "User authenticated",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.white,
                          textColor: AppColors.mainColor1,
                          fontSize: 16.0,
                        );
                        authenticated = true;
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const BottomNavBarBeamer(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
