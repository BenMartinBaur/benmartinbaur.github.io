# ADR 0001: Use React and Vite for the GitHub Pages site

## Status

Accepted on 2026-08-18.

## Context

The canonical GitHub Pages repository previously used Hugo. A separate React/Vite prototype now contains the accepted visual design, wording, legal pages, recruiting experience, search, theme behavior, and Markdown publishing model.

The existing Hugo content has been backed up and may be replaced. Content migration and visual comparison with the old site are not requirements.

## Decision

Use the current React/Vite application as the production source of truth.

Add build-time static route generation rather than returning to Hugo:

- preserve the current design and interactions without a template rewrite;
- emit clean, crawlable route documents;
- emit route-specific metadata, sitemap, RSS, robots, and 404 output;
- retain query-route compatibility for older links;
- deploy the verified `dist` artifact through GitHub Pages.

## Consequences

Positive:

- No visual or wording migration is required.
- Existing React components and Markdown bundles remain authoritative.
- GitHub Pages receives complete static route documents.
- Local preview and production use the same output.

Trade-offs:

- The project owns a small static route generator.
- React and Markdown rendering JavaScript are still shipped to visitors.
- Root-domain hosting is assumed by `base: '/'`.

## Revisit triggers

Reconsider the platform if:

- the custom generator becomes difficult to maintain;
- shipped JavaScript exceeds the documented budget;
- authoring requires multilingual or complex taxonomy features;
- the site needs server-side capabilities that GitHub Pages cannot provide.

