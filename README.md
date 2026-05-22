# PocketFi

PocketFi is a Flutter personal finance app for tracking everyday spending, receipts, wallets, budgets, bills, debts, and savings goals.

The current public launch surface is intentionally practical: source code, setup notes, project status, and issue tracking are available here while the app is prepared for a wider release.

## What PocketFi Does

- Track income, expenses, and transfers.
- Scan receipts and attach receipt images to transactions.
- Organize transactions by category, tags, wallet, and month.
- Manage budgets, bills, debts, savings goals, and shared wallets.
- Sync data through Firebase Authentication, Firestore, Cloud Storage, and Crashlytics.

## Project Status

PocketFi is in launch-preparation mode.

- Landing site target: `https://pocketfi-jellyy.web.app`
- Public issue tracker: [GitHub Issues](https://github.com/boonyongyang/pocketfi/issues)
- Source license: [MIT](LICENSE)
- Current release blockers are tracked through issues and launch notes, not store links.

## Local Setup

Prerequisites:

- Flutter SDK compatible with the SDK constraint in `pubspec.yaml`
- Firebase project with Authentication, Firestore, Cloud Storage, and Crashlytics enabled
- Android Studio or Xcode for mobile builds

Setup:

```sh
flutter pub get
flutter analyze
flutter test
```

Firebase:

- Android expects `android/app/google-services.json`.
- iOS expects `ios/Runner/GoogleService-Info.plist`.
- `lib/firebase_options.dart` should be regenerated with FlutterFire CLI when using a different Firebase project.

## Security And Privacy

PocketFi stores user-owned financial records. Treat issues involving account access, shared-wallet visibility, Firebase rules, receipt images, or data deletion as high priority.

For security reports, follow [SECURITY.md](SECURITY.md). Start with a minimal public issue asking for a private contact path and avoid posting secrets, tokens, personal financial data, or full receipt images publicly.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for local workflow, issue triage, and pull-request expectations.

## License

PocketFi is available under the [MIT License](LICENSE).
