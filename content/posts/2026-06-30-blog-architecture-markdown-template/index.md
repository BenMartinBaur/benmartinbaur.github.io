---
layout: post
title: "Blog Architecture, Markdown Syntax, and the Post Template I Recommend"
description: "A practical guide to structuring a Hugo blog, writing clean markdown, and using a repeatable post template that scales."
date: 2026-06-30
category: build
tags:
  - Hugo
  - Markdown
  - Documentation
  - Best Practices
reading_time: "9 min read"
---

## TL;DR

If your blog should scale beyond a few posts, you need three things: a clear content architecture, predictable markdown conventions, and a repeatable template. This post gives you all three in a format you can copy into your workflow immediately.

---

## Why this matters

Most blogs don’t fail because of content quality. They fail because of **inconsistency**:

- inconsistent post structure
- inconsistent markdown usage
- inconsistent metadata

That inconsistency makes it harder to read, harder to search, and harder to maintain.

The fix is simple: define your architecture once, then use a template for every post.

---

## 1) Recommended blog architecture

For this Hugo setup, keep each post in a **page bundle**:

```text
content/
  posts/
    2026-06-30-blog-architecture-markdown-template/
      index.md
      featured.jpg        # optional
      diagram.png         # optional
```

### Why page bundles

1. Media stays local to the post.
2. Moving/renaming content is safer.
3. Template logic can reliably discover related images like `featured.jpg`.

### Category and tag strategy

Use **one primary category** for intent and **3–5 tags** for discoverability.

- Category (single): `build`, `strategy`, or `real`
- Tags (multiple): specific topics (for example: `Hugo`, `Markdown`, `Pagefind`, `Leadership`)

This keeps navigation clean while still supporting deep search/filtering.

---

## 2) Markdown syntax guidelines (practical, not academic)

### Headings

- One `#` title comes from front matter.
- Start body content at `##`.
- Keep heading levels sequential (`##` → `###`).

### Emphasis

- Use `**bold**` for key points.
- Use `*italic*` sparingly for nuance.
- Avoid long ALL CAPS emphasis.

### Lists

Use bullets for unordered ideas:

- clear
- short
- parallel phrasing

Use numbered lists for sequence:

1. Do this first.
2. Then this.
3. Then validate.

### Code blocks

Always use fenced code blocks with language hints:

```bash
hugo server --disableFastRender --noHTTPCache
```

```toml
[doks]
  colorMode = "auto"
```

### Tables

Use tables for comparisons, not for decoration:

| Option | Best for | Trade-off |
|--------|----------|-----------|
| Short post | Fast publishing | Less depth |
| Structured post | Search + clarity | More writing discipline |

### Quotes and callouts

Use blockquotes only for principles worth remembering:

> Good architecture reduces decision fatigue for future you.

---

## 3) Recommended post template (copy/paste)

Use this as your default starting point:

```yaml
---
layout: post
title: "Your Post Title"
description: "One-sentence meta description (110–160 chars recommended)."
date: 2026-06-30
image: featured.jpg # optional
category: build
tags:
  - TopicOne
  - TopicTwo
  - TopicThree
reading_time: "7 min read"
---
```

```md
## TL;DR

2–4 sentences with the key takeaway and intended audience.

---

## Context

What problem are you solving and why should the reader care now?

---

## Approach

Describe the model/framework/architecture you used.

### Step 1

What you did and why.

### Step 2

What changed and how to validate it.

---

## Example

Add one concrete code/config/example block.

---

## Trade-offs

- What this approach is good at
- Where it breaks down
- When to choose an alternative

---

## Recommendation

State your opinion clearly in 3–5 bullets.

---

## Next step

Give the reader one concrete action.
```

---

## 4) Editorial quality checklist

Before publishing, check:

1. Title is specific and outcome-oriented.
2. Description is clear and not too long.
3. Headings are scannable.
4. At least one concrete example is included.
5. Recommendation section is explicit.
6. Links point to canonical sources.

---

## 5) Common mistakes to avoid

- Writing without a TL;DR.
- Using tags as categories.
- Overloading one post with multiple unrelated ideas.
- Skipping examples in technical posts.
- Publishing without a clear recommendation.

---

## Bottom line

A strong blog is an architecture problem first and a writing problem second.

If you standardize your post structure, markdown style, and metadata now, publishing gets faster, quality goes up, and your content remains maintainable as your library grows.
