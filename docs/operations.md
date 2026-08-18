# Operations

## Local production preview

```powershell
npm ci
npx playwright install chromium
npm run quality
npm run preview -- --host 127.0.0.1 --port 4174
```

Verify:

- `/`
- `/posts/about-ben-martin-baur/`
- `/privacy/`
- `/impressum/`
- `/recruiting/`
- `/robots.txt`
- `/sitemap.xml`
- `/index.xml`
- `/404.html`

## Publishing

1. Create or update a Markdown page bundle.
2. Run lint and build locally.
   - Prefer `npm run quality` before release.
3. Preview the generated route directly.
4. Commit and push to `main`.
5. Confirm the GitHub Pages workflow succeeds.
6. Smoke-test the public canonical route.

## Deployment failure

1. Open the failed GitHub Actions run.
2. Identify whether lint, TypeScript, Vite, route generation, verification, upload, or deploy failed.
3. Reproduce locally with `npm ci`, `npx playwright install chromium`, and `npm run quality`.
4. Correct the source rather than editing `dist`.
5. Push the fix and confirm the new deployment.

## Rollback

1. Identify the last known-good commit.
2. Revert the production change with a normal Git revert commit.
3. Push the revert to `main`.
4. Let the same Pages workflow rebuild and redeploy.
5. Verify the public home, article, legal, and recruiting routes.

Do not manually copy old Hugo output into `dist`; the backed-up repository remains the historical recovery source.

## Dependency updates

- Review runtime, build, and GitHub Action updates separately.
- Run the full local quality sequence after updates.
- Do not merge dependency updates that change generated routes or visual behavior without browser review.
