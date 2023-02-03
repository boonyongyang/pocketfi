import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketfi/state/auth/providers/auth_state_provider.dart';
import 'package:pocketfi/views/components/dialogs/alert_dialog_model.dart';
import 'package:pocketfi/views/components/dialogs/logout_dialog.dart';

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
class ProfilePage extends ConsumerStatefulWidget {
  // static String routeName = "/profile";
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();

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

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: const ProfilePageBody(),
    );
  }
}

class ProfilePageBody extends ConsumerStatefulWidget {
  const ProfilePageBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfilePageBodyState();
}

class _ProfilePageBodyState extends ConsumerState<ProfilePageBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const ProfilePagePicture(),
          const SizedBox(height: 20),
          ProfilePageMenu(
            text: "My Account",
            // icon: "assets/icons/User Icon.svg",
            icon: const Icon(Icons.person),
            press: () => {},
          ),
          ProfilePageMenu(
            text: "Notifications",
            // icon: "assets/icons/Bell.svg",
            icon: const Icon(Icons.notifications),
            press: () {},
          ),
          ProfilePageMenu(
            text: "Settings",
            // icon: "assets/icons/Settings.svg",
            icon: const Icon(Icons.settings),
            press: () => Beamer.of(context).beamToNamed('/d/settings'),
          ),
          ProfilePageMenu(
            text: "Help Center",
            // icon: "assets/icons/Question mark.svg",
            icon: const Icon(Icons.help),
            press: () {},
          ),
          ProfilePageMenu(
            text: "Log Out",
            // icon: "assets/icons/Log out.svg",
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

class ProfilePageMenu extends StatelessWidget {
  const ProfilePageMenu({
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

class ProfilePagePicture extends StatelessWidget {
  const ProfilePagePicture({
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
