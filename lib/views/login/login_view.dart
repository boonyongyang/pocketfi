import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/auth_state_provider.dart';
import 'package:pocketfi/views/constants/strings.dart';
import 'package:pocketfi/views/login/divider_with_margins.dart';
import 'package:pocketfi/views/login/google_button.dart';
import 'package:pocketfi/views/login/login_view_signup_links.dart';

import '../components/constants/app_colors.dart';
import 'facebook_button.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.appName,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                Strings.welcomeToAppName,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const DividerWithMargins(),
              Text(
                Strings.logIntoYourAccount,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(height: 1.5),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(80, 45),
                  backgroundColor: AppColors.loginButtonColor,
                  foregroundColor: AppColors.loginButtonTextColor,
                ),
                onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
                child: const GoogleButton(),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(80, 45),
                  backgroundColor: AppColors.loginButtonColor,
                  foregroundColor: AppColors.loginButtonTextColor,
                ),
                onPressed:
                    // ref.read(authStateProvider.notifier).loginWithFacebook,
                    () {},
                child: const FacebookButton(),
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

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           Strings.appName,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               const SizedBox(height: 20.0),
//               Text(
//                 Strings.welcomeToAppName,
//                 style: Theme.of(context).textTheme.subtitle1?.copyWith(
//                       height: 1.5,
//                     ),
//               ),
//               const DividerWithMargins(),
//               Text(
//                 Strings.logIntoYourAccount,
//                 style: Theme.of(context).textTheme.subtitle1?.copyWith(
//                       height: 1.5,
//                     ),
//               ),
//               const GoogleButton(),
//               const FacebookButton(),
//               const LoginViewSignupLinks(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }