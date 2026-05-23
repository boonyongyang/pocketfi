# PocketFi - Personal Finance App

PocketFi is an all-in-one personal finance app designed to help people track everyday finances in one place. It supports expenses, income, transfers, receipts, wallets, budgets, bills, debts, and savings goals.

PocketFi is currently in launch-preparation mode. The public launch surface is intentionally practical: app source, setup notes, project status, issue tracking, and security reporting are available here while the app is prepared for wider release.

![PocketFi screenshot](https://user-images.githubusercontent.com/55826849/230759898-d35204ae-65c9-4e5e-9f3e-ea862be3fde0.png)

## Public Links

- Landing site target: [pocketfi-jellyy.web.app](https://pocketfi-jellyy.web.app)
- Public issue tracker: [GitHub Issues](https://github.com/boonyongyang/pocketfi/issues)
- Security policy: [SECURITY.md](SECURITY.md)
- License: [MIT](LICENSE)

Current release blockers are tracked through issues and launch notes, not app-store links.

## Features

- **Track expenses and income**: Add transactions and categorize them for easier tracking.
- **Transfers**: Record money movement between wallets.
- **Receipt scanning**: Scan receipts and keep digital records with transactions.
- **Bookmarks**: Save frequently used transactions for quick reuse.
- **Overview dashboard**: View spending, income, and monthly activity from the home timeline.
- **Category breakdowns**: Review expenses and income grouped by category.
- **Spending trends**: Analyze spending patterns over time.
- **Bills**: Track bill amounts, due dates, and payment status.
- **Shared wallets**: Share a wallet with another user for joint expense tracking.
- **Budgets**: Set category budgets and review monthly usage.
- **Debts**: Track debts, payment schedules, and payoff progress.
- **Savings goals**: Visualize savings progress with goal tracking.

## Demo

### View Expenditure Overview

<img src="https://user-images.githubusercontent.com/55826849/230754276-a7ec00c4-ceb8-4d4e-bc48-76da45e6de63.GIF" alt="View expenditure overview" width="400" />

### Receipt Text Highlighter

<img src="https://user-images.githubusercontent.com/55826849/230755142-2bc2b923-69a5-4c5a-9c24-db86fc1bd47c.gif" alt="Receipt text highlighter" width="400" />

### Budget

<img src="https://user-images.githubusercontent.com/55826849/230755819-aedb9570-201a-4943-b54c-475573863b6f.gif" alt="Budget demo" width="400" />

### Debt

<img src="https://user-images.githubusercontent.com/55826849/230760293-da884d7a-62fd-4290-b670-8e9031a2cbcd.gif" alt="Debt demo" width="400" />

### Saving Goal

<img src="https://user-images.githubusercontent.com/55826849/230755815-61803a23-59e4-46fe-a159-0fa4ca5597d9.gif" alt="Saving goal demo" width="400" />

## Tech Stack

- Flutter
- Firebase Authentication
- Cloud Firestore
- Firebase Cloud Storage
- Firebase Crashlytics
- Riverpod for state management

## Architecture

PocketFi uses Riverpod for app state and keeps most feature code organized into these folders:

- `application`: Riverpod providers, notifiers, and feature coordination.
- `data`: Firebase repositories and persistence logic.
- `domain`: Models, enums, and value objects.
- `presentation`: Screens, widgets, sheets, and user flows.

Major feature areas live under `lib/src/features/`, including account, authentication, bills, bookmarks, budgets, categories, debts, receipts, saving goals, tags, transactions, and wallets.

## Local Setup

Prerequisites:

- Flutter SDK compatible with the SDK constraint in `pubspec.yaml`
- Firebase project with Authentication, Firestore, Cloud Storage, and Crashlytics enabled
- Android Studio and/or Xcode for mobile builds

Install dependencies and run checks:

```sh
flutter pub get
flutter analyze
flutter test
```

Firebase setup:

1. Create a Firebase project in the Firebase Console.
2. Add an Android app and place `google-services.json` in `android/app/`.
3. Add an iOS app and place `GoogleService-Info.plist` in `ios/Runner/`.
4. Enable Authentication, Firestore, Cloud Storage, and Crashlytics.
5. Regenerate `lib/firebase_options.dart` with the FlutterFire CLI when using a different Firebase project.

Firestore rules are included in [firestore.rules](firestore.rules).

## Security And Privacy

PocketFi stores user-owned financial records. Treat issues involving account access, shared-wallet visibility, Firebase rules, receipt images, or data deletion as high priority.

For security reports, follow [SECURITY.md](SECURITY.md). Start with a minimal public issue asking for a private contact path and avoid posting secrets, tokens, personal financial data, or full receipt images publicly.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for local workflow, issue triage, and pull-request expectations.

## License

PocketFi is available under the [MIT License](LICENSE).
