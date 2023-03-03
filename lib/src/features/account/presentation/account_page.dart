import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/logout_dialog.dart';
import 'package:pocketfi/src/constants/app_colors.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/features/account/presentation/setting_page.dart';
import 'package:pocketfi/src/features/authentication/application/auth_state_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_id_provider.dart';
import 'package:pocketfi/src/features/authentication/application/user_info_model_provider.dart';
import 'package:pocketfi/src/features/category/presentation/category_page.dart';
import 'package:pocketfi/src/features/shared/tabs/tab_controller_notifiers.dart';

// const AppColors.mainColor1 = Color(0xFFFF7643);
// const kPrimaryLightColor = Color(0xFFFFECDF);
// const kPrimaryGradientColor = LinearGradient(
//   begin: Alignment.topLeft,
//   end: Alignment.bottomRight,
//   colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
// );
// const kSecondaryColor = Color(0xFF979797);
// const kTextColor = Color(0xFF757575);

@immutable
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
      ),
      body: const AccountPageBody(),
    );
  }
}

class AccountPageBody extends ConsumerWidget {
  const AccountPageBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const AccountPagePicture(),
          const SizedBox(height: 20),
          const AccountPageUserInfo(),
          // AccountPageMenu(
          //   text: "My Account",
          //   icon: const Icon(Icons.person),
          //   press: () => {},
          // ),
          AccountPageMenu(text: "Wallets", icon: AppIcons.wallet, press: () {}),
          AccountPageMenu(
            text: "Categories",
            icon: Icons.category,
            press: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => const CategoryPage(),
                fullscreenDialog: true,
              ),
            ),
          ),
          AccountPageMenu(
              text: "Tags", icon: Icons.label_important_outline, press: () {}),
          // AccountPageMenu(
          // text: "Notifications", icon: Icons.notifications, press: () {}),
          AccountPageMenu(
            text: "Settings",
            icon: Icons.settings,
            // press: () => Beamer.of(context).beamToNamed('/d/settings'),
            press: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
                fullscreenDialog: true,
              ),
            ),
          ),
          AccountPageMenu(
            text: "Help Center",
            icon: Icons.help,
            press: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => const EgTabsPage(),
                fullscreenDialog: true,
              ),
            ),
          ),
          AccountPageMenu(
            text: "Log Out",
            color: Colors.red,
            icon: Icons.logout,
            press: () async {
              final shouldLogOut =
                  await const LogoutDialog().present(context).then(
                        (value) => value ?? false,
                      );
              if (shouldLogOut) {
                await ref.read(authStateProvider.notifier).logOut();
              }
            },
          ),
        ],
      ),
    );
  }
}

class AccountPageMenu extends StatelessWidget {
  const AccountPageMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.color = AppColors.mainColor1,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mainColor1,
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            // SvgPicture.asset(
            //   icon,
            //   color: AppColors.mainColor1,
            //   width: 22,
            // ),
            Icon(icon, color: color),
            const SizedBox(width: 20),
            Expanded(child: Text(text, style: TextStyle(color: color))),
            Icon(Icons.arrow_forward_ios, color: color),
          ],
        ),
      ),
    );
  }
}

class AccountPagePicture extends StatelessWidget {
  const AccountPagePicture({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            child: Icon(
              Icons.face_4_outlined,
              size: 75.0,
              color: AppColors.mainColor2,
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.mainColor1,
                  size: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AccountPageUserInfo extends ConsumerWidget {
  const AccountPageUserInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(
        ref.watch(userIdProvider).toString(),
      ),
    );

    return Column(
      children: [
        Text('User ID: ${userInfo.value?.userId}'),
        Text('Name: ${userInfo.value?.displayName}'),
        Text('Email: ${userInfo.value?.email}'),
      ],
    );
  }
}
