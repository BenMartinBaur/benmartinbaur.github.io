import { access, readFile, readdir } from 'node:fs/promises'
import path from 'node:path'

const distDir = path.join(process.cwd(), 'dist')
const requiredFiles = [
  'index.html',
  'privacy/index.html',
  'impressum/index.html',
  'recruiting/index.html',
  '404.html',
  'robots.txt',
  'sitemap.xml',
  'index.xml',
]

for (const relativePath of requiredFiles) {
  await access(path.join(distDir, relativePath))
}

const postEntries = await readdir(path.join(distDir, 'posts'), {
  withFileTypes: true,
})
const postRoutes = postEntries.filter((entry) => entry.isDirectory())
if (postRoutes.length === 0) throw new Error('No static post routes were generated.')

const htmlFiles = [
  'index.html',
  'privacy/index.html',
  'impressum/index.html',
  'recruiting/index.html',
  ...postRoutes.map((entry) => `posts/${entry.name}/index.html`),
]

for (const relativePath of htmlFiles) {
  const html = await readFile(path.join(distDir, relativePath), 'utf8')
  const requirements = [
    ['canonical URL', /rel="canonical"/],
    ['description', /name="description"/],
    ['Open Graph title', /property="og:title"/],
    ['JSON-LD', /type="application\/ld\+json"/],
    ['root-relative application asset', /(?:src|href)="\/assets\//],
  ]
  for (const [name, pattern] of requirements) {
    if (!pattern.test(html)) {
      throw new Error(`${relativePath} is missing ${name}.`)
    }
  }
}

const robots = await readFile(path.join(distDir, 'robots.txt'), 'utf8')
if (!robots.includes('Sitemap: https://benmartinbaur.github.io/sitemap.xml')) {
  throw new Error('robots.txt does not reference the production sitemap.')
}

const sitemap = await readFile(path.join(distDir, 'sitemap.xml'), 'utf8')
for (const route of ['/', '/privacy/', '/impressum/', '/recruiting/']) {
  if (!sitemap.includes(`https://benmartinbaur.github.io${route}`)) {
    throw new Error(`sitemap.xml is missing ${route}.`)
  }
}

console.log(`Verified ${htmlFiles.length} static route documents and discovery files.`)
