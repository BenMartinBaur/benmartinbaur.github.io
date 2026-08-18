# Authoring blog posts

Each article is a page bundle under `src/content/posts/`:

```text
YYYY-MM-DD-your-post-slug/
  index.md
  optional-image.webp
```

Copy `_template/` to start a post. The folder date should match the `date` in front matter. The text after the date becomes the route slug, for example `2026-08-18-my-post` becomes `?post=my-post`.

## Front matter

Required fields:

- `title`: Article and card title.
- `description`: Latest-card, search, and page metadata summary.
- `date`: Publication date in `YYYY-MM-DD` format.
- `category`: Category filter label.

Optional fields:

- `tags`: List displayed on the article.
- `reading_time`: Display value such as `"7 min read"`. It is calculated when omitted.
- `image`: Relative path to an image stored in the bundle.
- `draft`: Set to `true` to exclude the post. Defaults to `false`.

Posts dated after the current date are excluded automatically. Invalid metadata or missing referenced images fail clearly rather than publishing incomplete content.

## Markdown and images

GitHub-flavored Markdown is supported, including headings, links, images, blockquotes, ordered and unordered lists, task lists, tables, inline code, and fenced code blocks. Raw HTML is intentionally not rendered.

Store article media beside `index.md` and use a relative path:

```md
![Architecture overview](./architecture.webp)
```

External links open in a new tab. Site-relative and query links remain in the current tab.

## Publish workflow

1. Copy `_template/` to a new dated folder.
2. Complete the front matter and article body.
3. Add images to the same bundle and reference them relatively.
4. Set `draft: false`.
5. Run `npm run build`.
6. Commit and push. The GitHub Pages workflow publishes the new build.

No application code or post registry needs to be changed.
