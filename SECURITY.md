# Security Policy

PocketFi handles user-owned financial records, receipt images, and account metadata. Treat anything involving account access, shared-wallet visibility, Firebase rules, storage permissions, deletion, or receipt exposure as security sensitive.

## Reporting

Until a private security advisory flow is enabled, do not post secrets, tokens, personal financial data, full receipt images, or complete exploit steps in public.

Open a minimal GitHub issue with:

- Affected area
- Severity estimate
- Whether user data or account access is involved
- A request for a private follow-up path

Maintainers will verify the report and move detailed reproduction steps to a private channel before investigation.

## Scope

In scope:

- Firebase Authentication access issues
- Firestore or Cloud Storage authorization gaps
- Shared-wallet data visibility bugs
- Account deletion or export privacy issues
- Receipt image exposure

Out of scope:

- Social engineering
- Denial-of-service against GitHub or Firebase
- Reports requiring access to another user's real account without consent

