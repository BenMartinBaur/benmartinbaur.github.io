# Architecture

## Overview

B3N.B4UR_ is a static GitHub Pages site with React-enhanced interactions. Markdown is the content source; the build produces a complete HTML document for every public route.

```text
Markdown page bundles
        |
        v
Vite content discovery and React bundle
        |
        v
Static route generator
        |
        +--> Route HTML and metadata
        +--> Sitemap
        +--> RSS
        +--> Robots
        +--> 404
        |
        v
Static build verifier
        |
        v
GitHub Pages artifact
```

## Runtime framework

- `src/App.tsx` owns page composition, navigation, search, theme switching, legal pages, and route selection.
- `src/RecruitingPage.tsx` owns the recruiter-focused executive profile.
- `src/posts.ts` discovers Markdown bundles through Vite, validates front matter, filters drafts and future posts, resolves local assets, and exposes published posts to React.
- `src/App.css`, `src/RecruitingPage.css`, and `src/index.css` implement the accepted visual system.

## Content architecture

Each article is a page bundle:

```text
src/content/posts/YYYY-MM-DD-slug/
  index.md
  local-assets
```

The browser renderer uses safe GitHub-flavored Markdown. Raw HTML is not enabled.

## Static delivery

After Vite creates `dist`, `scripts/generate-static-routes.mjs`:

1. Reads published Markdown front matter.
2. Creates canonical route documents.
3. Adds route-specific title, description, canonical, Open Graph, Twitter, and JSON-LD metadata.
4. Creates sitemap, RSS, robots, and 404 output.

`scripts/verify-static-build.mjs` fails the build when required routes or metadata are missing.

Clean paths are the canonical URLs. Query-string routes remain readable by the React router for compatibility with older links.

## Hosting

The site is designed for the root user site:

```text
https://benmartinbaur.github.io/
```

Vite therefore uses `base: '/'`. GitHub Actions supplies the Pages base URL to the static generator through `SITE_URL`.

## Trust boundaries

- Markdown files are trusted repository content but cannot inject raw HTML through React Markdown.
- Front matter is validated before rendering.
- Missing local post assets fail explicitly.
- GitHub Pages serves only generated static files.
- No tracking or analytics scripts are included.

