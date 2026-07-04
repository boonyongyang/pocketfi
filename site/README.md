# PocketFi Landing Site Source

This directory mirrors the static landing site deployed at:

- https://mypocketfi.web.app

Contents:

- `landing/`: static HTML, images, manifest, robots, and sitemap files.
- `firebase.json`: Firebase Hosting configuration for the mirrored site source.
- `.firebaserc.example`: current Firebase project mapping used by the production deployment.

The canonical production host is Firebase Hosting site `mypocketfi` in project `pocketfi-jellyy`.

The private app repo currently remains the deploy authority. This public copy exists so the public launch surface can be inspected alongside README, support, security, and issue-template material.

Before using this folder for deployment, verify:

1. `firebase.json` still points at `landing/`.
2. `.firebaserc.example` matches the intended Firebase project.
3. `landing/sitemap.xml` and canonical metadata still point at `https://mypocketfi.web.app`.
4. No app-store, support email, or source-audit claims have been added unless they are actually true.

