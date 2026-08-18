import assert from 'node:assert/strict'
import { readdir, readFile } from 'node:fs/promises'
import path from 'node:path'
import test from 'node:test'
import { parse } from 'yaml'

const root = process.cwd()
const distDir = path.join(root, 'dist')
const sourcePostsDir = path.join(root, 'src', 'content', 'posts')

async function publishedPostSlugs() {
  const entries = await readdir(sourcePostsDir, { withFileTypes: true })
  const today = new Date().toISOString().slice(0, 10)
  const slugs = []

  for (const entry of entries) {
    if (!entry.isDirectory() || entry.name.startsWith('_')) continue
    const bundleFiles = await readdir(path.join(sourcePostsDir, entry.name))
    if (!bundleFiles.includes('index.md')) continue
    const source = await readFile(
      path.join(sourcePostsDir, entry.name, 'index.md'),
      'utf8',
    )
    const frontMatter = source.match(/^---\r?\n([\s\S]*?)\r?\n---/)
    assert.ok(frontMatter, `${entry.name} has front matter`)
    const metadata = parse(frontMatter[1])
    if (metadata.draft === true || metadata.date > today) continue
    slugs.push(entry.name.replace(/^\d{4}-\d{2}-\d{2}-/, ''))
  }

  return slugs.sort()
}

test('every published post has one static route with metadata', async () => {
  const expected = await publishedPostSlugs()
  const entries = await readdir(path.join(distDir, 'posts'), {
    withFileTypes: true,
  })
  const generated = entries
    .filter((entry) => entry.isDirectory())
    .map((entry) => entry.name)
    .sort()

  assert.deepEqual(generated, expected)
  for (const slug of expected) {
    const html = await readFile(
      path.join(distDir, 'posts', slug, 'index.html'),
      'utf8',
    )
    assert.match(html, new RegExp(`rel="canonical" href="[^"]*/posts/${slug}/"`))
    assert.match(html, /property="og:type" content="article"/)
    assert.match(html, /"@type":"BlogPosting"/)
  }
})

test('discovery files contain every canonical route', async () => {
  const slugs = await publishedPostSlugs()
  const sitemap = await readFile(path.join(distDir, 'sitemap.xml'), 'utf8')
  const rss = await readFile(path.join(distDir, 'index.xml'), 'utf8')
  const robots = await readFile(path.join(distDir, 'robots.txt'), 'utf8')

  for (const route of [
    '/',
    '/privacy/',
    '/impressum/',
    '/recruiting/',
    ...slugs.map((slug) => `/posts/${slug}/`),
  ]) {
    assert.ok(sitemap.includes(`https://benmartinbaur.github.io${route}`))
  }
  for (const slug of slugs) {
    assert.ok(rss.includes(`https://benmartinbaur.github.io/posts/${slug}/`))
  }
  assert.match(
    robots,
    /Sitemap: https:\/\/benmartinbaur\.github\.io\/sitemap\.xml/,
  )
})

