# email-assets

Public CDN repository for static assets used in HTML email templates.

Deployed via **Vercel** as a static site — no build step, files are served from the repo root as-is.

## Why Vercel

- Stable, production-grade CDN with global edge caching
- Correct `Content-Type` and `Cache-Control` headers for images out of the box
- No bandwidth restrictions (unlike GitHub Pages)
- Auto-deploys on every push to `main`

## Structure

```
email-assets/
└── [company]/
    └── static/
        └── [files]
```

Each company gets its own folder mirroring the `emails/[company]/static/` path in the private `react-email-starter` repo.

## URL pattern

```
https://email-assets.vercel.app/[company]/static/[filename]
```

Example:
```
https://email-assets.vercel.app/velobeat/static/team.jpg
```

This base URL is configured in the private repo at `emails/[company]/theme.ts` → `cdnBaseURL`.

## Adding a new company

1. Create `[company]/static/` folder in this repo
2. Add the image files
3. Push to `main` — Vercel deploys automatically
4. Set `cdnBaseURL` in the private repo's `emails/[company]/theme.ts` to the new base URL

## What belongs here

- Images: `.jpg`, `.jpeg`, `.png`, `.gif`, `.webp`, `.svg`
- Other media: fonts, icons referenced in emails

## Auto-push watcher

`watch-and-push.ps1` watches the repo for new images and automatically commits and pushes them.

**Run:**
```powershell
.\watch-and-push.ps1
```

- Detects new `.jpg`, `.jpeg`, `.png`, `.webp` files via `git status`
- Waits 10 seconds — if the file is still there, commits and pushes
- Auto-generates a commit message from the filename(s)
- Stop with `Ctrl+C`

## What does NOT belong here

- HTML files or compiled email output
- TSX/JSX components
- Config files, `package.json`, build artifacts
- Any source code from the private repo
