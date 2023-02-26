import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/src/common_widgets/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/src/common_widgets/dialogs/logout_dialog.dart';
import 'package:pocketfi/src/constants/app_icons.dart';
import 'package:pocketfi/src/features/account/presentation/setting_page.dart';
import 'package:pocketfi/src/features/authentication/application/auth_state_provider.dart';

const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

@immutable
class AccountPage extends ConsumerStatefulWidget {
  // static String routeName = "/account";
  const AccountPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountPageState();

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text("Profile"),
  //     ),
  //     body: const ProfilePageBody(),
  //     // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile),
  //   );
  // }
}

class _AccountPageState extends ConsumerState<AccountPage> {
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

class AccountPageBody extends ConsumerStatefulWidget {
  const AccountPageBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AccountPageBodyState();
}

class _AccountPageBodyState extends ConsumerState<AccountPageBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const AccountPagePicture(),
          const SizedBox(height: 20),
          AccountPageMenu(
            text: "My Account",
            icon: const Icon(Icons.person),
            press: () => {},
          ),
          AccountPageMenu(
            text: "Wallets",
            icon: const Icon(AppIcons.wallet),
            press: () {},
          ),
          AccountPageMenu(
            text: "Categories",
            icon: const Icon(Icons.category),
            press: () {},
          ),
          AccountPageMenu(
            text: "Notifications",
            icon: const Icon(Icons.notifications),
            press: () {},
          ),
          AccountPageMenu(
            text: "Settings",
            icon: const Icon(Icons.settings),
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
            icon: const Icon(Icons.help),
            press: () {},
          ),
          AccountPageMenu(
            text: "Log Out",
            icon: const Icon(Icons.logout),
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
    this.press,
  }) : super(key: key);

  final String text;
  final Icon icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: kPrimaryColor,
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
            //   color: kPrimaryColor,
            //   width: 22,
            // ),
            icon,
            const SizedBox(width: 20),
            Expanded(child: Text(text)),
            const Icon(Icons.arrow_forward_ios),
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
              // backgroundImage: AssetImage(""),
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
                  color: kPrimaryColor,
                  size: 16,
                ),
                // child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
