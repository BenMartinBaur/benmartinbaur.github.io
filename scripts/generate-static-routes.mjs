import { readdir, readFile, writeFile, mkdir } from 'node:fs/promises'
import path from 'node:path'
import { parse } from 'yaml'

const root = process.cwd()
const distDir = path.join(root, 'dist')
const postsDir = path.join(root, 'src', 'content', 'posts')
const siteUrl = (process.env.SITE_URL ?? 'https://benmartinbaur.github.io').replace(
  /\/+$/,
  '',
)

function escapeHtml(value) {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('"', '&quot;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
}

function escapeXml(value) {
  return escapeHtml(value).replaceAll("'", '&apos;')
}

function parseFrontMatter(source, sourcePath) {
  const match = source.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/)
  if (!match) throw new Error(`Missing front matter in ${sourcePath}.`)
  const metadata = parse(match[1])
  return { metadata, markdown: match[2].trim() }
}

function todayInBerlin() {
  const parts = new Intl.DateTimeFormat('en-CA', {
    timeZone: 'Europe/Berlin',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).formatToParts(new Date())
  const part = (type) => parts.find((entry) => entry.type === type)?.value
  return `${part('year')}-${part('month')}-${part('day')}`
}

async function loadPosts() {
  const entries = await readdir(postsDir, { withFileTypes: true })
  const today = todayInBerlin()
  const posts = []

  for (const entry of entries) {
    if (!entry.isDirectory() || entry.name.startsWith('_')) continue
    const bundlePath = path.join(postsDir, entry.name)
    const bundleEntries = await readdir(bundlePath)
    if (!bundleEntries.includes('index.md')) continue
    const sourcePath = path.join(bundlePath, 'index.md')
    const source = await readFile(sourcePath, 'utf8')
    const { metadata, markdown } = parseFrontMatter(source, sourcePath)
    if (metadata.draft === true || metadata.date > today) continue

    const slug = entry.name.replace(/^\d{4}-\d{2}-\d{2}-/, '')
    if (!slug || slug === entry.name) {
      throw new Error(`Post bundle ${entry.name} requires a dated slug.`)
    }

    posts.push({
      slug,
      title: metadata.title,
      description: metadata.description,
      date: metadata.date,
      category: metadata.category,
      tags: metadata.tags ?? [],
      markdown,
    })
  }

  return posts.sort((left, right) => right.date.localeCompare(left.date))
}

function metadataBlock({ title, description, pathname, type, date, tags, noindex }) {
  const url = `${siteUrl}${pathname}`
  const jsonLd =
    type === 'article'
      ? {
          '@context': 'https://schema.org',
          '@type': 'BlogPosting',
          headline: title,
          description,
          datePublished: date,
          mainEntityOfPage: url,
          author: {
            '@type': 'Person',
            name: 'Ben Martin Baur',
            url: siteUrl,
          },
          keywords: tags,
        }
      : {
          '@context': 'https://schema.org',
          '@type': type === 'website' ? 'WebSite' : 'WebPage',
          name: title,
          description,
          url,
        }

  return [
    '<!-- static-route-metadata:start -->',
    `    <link rel="canonical" href="${escapeHtml(url)}" />`,
    `    <meta property="og:type" content="${type === 'article' ? 'article' : 'website'}" />`,
    `    <meta property="og:site_name" content="B3N.B4UR_" />`,
    `    <meta property="og:title" content="${escapeHtml(title)}" />`,
    `    <meta property="og:description" content="${escapeHtml(description)}" />`,
    `    <meta property="og:url" content="${escapeHtml(url)}" />`,
    '    <meta name="twitter:card" content="summary" />',
    `    <meta name="twitter:title" content="${escapeHtml(title)}" />`,
    `    <meta name="twitter:description" content="${escapeHtml(description)}" />`,
    noindex ? '    <meta name="robots" content="noindex" />' : '',
    type === 'article'
      ? `    <meta property="article:published_time" content="${escapeHtml(date)}" />`
      : '',
    `    <script type="application/ld+json">${JSON.stringify(jsonLd).replaceAll('<', '\\u003c')}</script>`,
    '    <!-- static-route-metadata:end -->',
  ]
    .filter(Boolean)
    .join('\n')
}

function renderHtml(template, metadata) {
  return template
    .replace(/<title>[\s\S]*?<\/title>/, `<title>${escapeHtml(metadata.title)}</title>`)
    .replace(
      /<meta\s+name="description"\s+content="[^"]*"\s*\/>/,
      `<meta name="description" content="${escapeHtml(metadata.description)}" />`,
    )
    .replace(
      /\s*<!-- static-route-metadata:start -->[\s\S]*?<!-- static-route-metadata:end -->/,
      '',
    )
    .replace('</head>', `${metadataBlock(metadata)}\n  </head>`)
}

async function writeRoute(template, pathname, metadata) {
  const relativePath =
    pathname === '/'
      ? 'index.html'
      : path.join(pathname.replace(/^\/|\/$/g, ''), 'index.html')
  const outputPath = path.join(distDir, relativePath)
  await mkdir(path.dirname(outputPath), { recursive: true })
  await writeFile(outputPath, renderHtml(template, { ...metadata, pathname }))
}

const template = await readFile(path.join(distDir, 'index.html'), 'utf8')
const posts = await loadPosts()

await writeRoute(template, '/', {
  title: 'B3N.B4UR_ — Be. Extrodenary. Now.',
  description:
    'Ideas and practical patterns about AI architecture, career development, and leadership.',
  type: 'website',
})

const staticPages = [
  {
    pathname: '/privacy/',
    title: 'Privacy | B3N.B4UR_',
    description:
      'Privacy information for the B3N.B4UR_ website, including data processing, hosting, cookies, and user rights.',
  },
  {
    pathname: '/impressum/',
    title: 'Impressum | B3N.B4UR_',
    description:
      'Legal notice and provider information for Ben Martin Baur and B3N.B4UR_.',
  },
  {
    pathname: '/recruiting/',
    title: 'Recruiting Agents & Recruiters | B3N.B4UR_',
    description:
      'Executive profile, experience, capabilities, recognition, and direct links for recruiting agents and recruiters.',
  },
]

for (const page of staticPages) {
  await writeRoute(template, page.pathname, { ...page, type: 'webpage' })
}

for (const post of posts) {
  await writeRoute(template, `/posts/${post.slug}/`, {
    title: `${post.title} | B3N.B4UR_`,
    description: post.description,
    type: 'article',
    date: post.date,
    tags: post.tags,
  })
}

const notFound = renderHtml(template, {
  title: 'Page not found | B3N.B4UR_',
  description: 'Return to B3N.B4UR_ for writing about AI, career, and leadership.',
  pathname: '/404.html',
  type: 'webpage',
  noindex: true,
})
await writeFile(path.join(distDir, '404.html'), notFound)

const sitemapRoutes = [
  { pathname: '/', date: posts[0]?.date },
  ...staticPages.map((page) => ({ pathname: page.pathname })),
  ...posts.map((post) => ({
    pathname: `/posts/${post.slug}/`,
    date: post.date,
  })),
]
const sitemap = [
  '<?xml version="1.0" encoding="UTF-8"?>',
  '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">',
  ...sitemapRoutes.map(
    ({ pathname, date }) =>
      `  <url><loc>${escapeXml(`${siteUrl}${pathname}`)}</loc>${date ? `<lastmod>${date}</lastmod>` : ''}</url>`,
  ),
  '</urlset>',
].join('\n')
await writeFile(path.join(distDir, 'sitemap.xml'), sitemap)

const rss = [
  '<?xml version="1.0" encoding="UTF-8"?>',
  '<rss version="2.0"><channel>',
  '  <title>B3N.B4UR_</title>',
  `  <link>${escapeXml(siteUrl)}</link>`,
  '  <description>Ideas and practical patterns about AI architecture, career development, and leadership.</description>',
  ...posts.map((post) => {
    const url = `${siteUrl}/posts/${post.slug}/`
    return [
      '  <item>',
      `    <title>${escapeXml(post.title)}</title>`,
      `    <link>${escapeXml(url)}</link>`,
      `    <guid>${escapeXml(url)}</guid>`,
      `    <pubDate>${new Date(`${post.date}T12:00:00Z`).toUTCString()}</pubDate>`,
      `    <description>${escapeXml(post.description)}</description>`,
      '  </item>',
    ].join('\n')
  }),
  '</channel></rss>',
].join('\n')
await writeFile(path.join(distDir, 'index.xml'), rss)

await writeFile(
  path.join(distDir, 'robots.txt'),
  `User-agent: *\nAllow: /\n\nSitemap: ${siteUrl}/sitemap.xml\n`,
)

console.log(
  `Generated ${posts.length + staticPages.length + 1} canonical routes, sitemap, RSS, robots, and 404.`,
)
