import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future<Uri> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      link: Uri.parse("https://pocketfi.page.link/wallet"),
      uriPrefix: "https://pocketfi.page.link",
      androidParameters: const AndroidParameters(
        packageName: 'your_android_package_name',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'your_ios_bundle_identifier',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(parameters);
    return dynamicLink;
  }
}
