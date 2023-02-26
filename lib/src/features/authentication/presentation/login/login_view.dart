import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/animations/lottie_animation_view.dart';
import 'package:pocketfi/src/common_widgets/animations/models/lottie_animation.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/strings.dart';
import 'package:pocketfi/src/features/authentication/application/auth_state_provider.dart';
import 'package:pocketfi/src/features/authentication/presentation/login/divider_with_margins.dart';
import 'package:pocketfi/src/features/authentication/presentation/login/google_button.dart';
import 'package:pocketfi/src/features/authentication/presentation/login/login_view_signup_links.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     Strings.appName,
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              Transform.scale(
                  scale: 0.75,
                  child: const LottieAnimationView(
                      animation: LottieAnimation.welcomeApp)),
              Center(
                child: Text(
                  Strings.welcomeToAppName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppSwatches.mainColor1,
                      ),
                ),
              ),
              const DividerWithMargins(),
              Text(
                Strings.logIntoYourAccount,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(height: 1.5),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(80, 55),
                  backgroundColor: AppSwatches.loginButtonColor,
                  foregroundColor: AppSwatches.loginButtonTextColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
                onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
                child: const GoogleButton(),
              ),
              const SizedBox(
                height: 20,
              ),
              const DividerWithMargins(),
              const LoginViewSignupLinks(),
            ],
          ),
        ),
      ),
    );
  }
}
