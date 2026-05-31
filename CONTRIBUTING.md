# Contributing

Thanks for helping improve PocketFi.

## Local Workflow

```sh
flutter pub get
flutter analyze
flutter test
```

Keep pull requests focused. Prefer one behavior change, bug fix, or documentation update per PR.

## Good First Contributions

- Reproduce and document bugs with exact device, OS, and Flutter version.
- Improve setup docs or screenshots.
- Add tests for transaction, wallet, budget, bill, or receipt flows.
- Tighten Firebase rule coverage and security notes.

## Pull Request Checklist

- Describe the user-facing change.
- Link the issue when one exists.
- Include screenshots or screen recordings for UI changes.
- State which checks were run.
- Do not include secrets, Firebase private config, keystores, personal receipts, or production user data.

## Security And Privacy

Do not post private financial records, API keys, Firebase tokens, keystores, or full receipt images in public issues or PRs.

If you believe you found a vulnerability, follow [SECURITY.md](SECURITY.md). Include only the affected area and severity until a private channel is available.
