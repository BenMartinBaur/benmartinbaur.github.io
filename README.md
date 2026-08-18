# B3N.B4UR_

Personal writing and executive profile site for Ben Martin Baur, built as a static React application for `https://benmartinbaur.github.io/`.

## Stack

- React 19 and TypeScript
- Vite 8
- React Markdown with GitHub-flavored Markdown
- YAML front matter
- Lucide icons
- Oxlint
- GitHub Actions and GitHub Pages

## Local development

Requirements:

- Node.js 24 or newer
- npm

```powershell
npm ci
npm run dev
```

The development server prints its local URL.

## Production-equivalent local preview

```powershell
npm run build
npm run preview -- --host 127.0.0.1 --port 4174
```

Open `http://127.0.0.1:4174/`.

The build generates real static documents for:

- `/`
- `/posts/<slug>/`
- `/privacy/`
- `/impressum/`
- `/recruiting/`
- `/404.html`

It also generates `robots.txt`, `sitemap.xml`, and `index.xml`.

## Publishing a post

Posts are dated page bundles under `src/content/posts/`:

```text
src/content/posts/
  2026-08-18-example-post/
    index.md
    optional-image.webp
```

Copy `src/content/posts/_template/`, complete the front matter, and set `draft: false`. The post is added to the home page, search, category filters, static routes, sitemap, and RSS feed during the next build.

See [`src/content/posts/README.md`](src/content/posts/README.md) for the complete authoring contract.

## Quality commands

```powershell
npx playwright install chromium
npm run quality
```

The quality pipeline includes:

- Oxlint and TypeScript compilation
- production build and static route verification
- Node integration tests for posts, metadata, sitemap, RSS, and robots
- generated internal-link and asset validation
- production dependency audit
- Playwright route, search, legacy URL, theme, mobile overflow, and axe tests
- Lighthouse budgets across Home, Article, Privacy, and Recruiting

`npm run build` performs TypeScript compilation, the Vite production build, static route generation, and output verification.

## Deployment

Pushes to `main` run `.github/workflows/deploy-pages.yml`. The workflow installs dependencies, lints, builds, verifies, uploads `dist`, and deploys through the protected GitHub Pages environment.

The existing Hugo content can be replaced because this repository is the selected production source for the new site. Do not commit generated `dist` files.

## Documentation

- [Architecture](docs/architecture.md)
- [Platform decision](docs/adr/0001-static-site-platform.md)
- [Operations](docs/operations.md)
- [Post authoring](src/content/posts/README.md)
