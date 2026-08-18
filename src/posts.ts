import { parse } from 'yaml'

export type Post = {
  slug: string
  category: string
  title: string
  excerpt: string
  date: string
  dateIso: string
  readingTime: string
  number: string
  tags: string[]
  image?: string
  markdown: string
  sourcePath: string
}

type PostFrontMatter = {
  title: string
  description: string
  date: string
  category: string
  tags: string[]
  readingTime?: string
  image?: string
  draft: boolean
}

const markdownModules = import.meta.glob('./content/posts/**/index.md', {
  eager: true,
  query: '?raw',
  import: 'default',
}) as Record<string, string>

const assetModules = import.meta.glob(
  './content/posts/**/*.{avif,gif,jpeg,jpg,png,svg,webp}',
  {
    eager: true,
    query: '?url',
    import: 'default',
  },
) as Record<string, string>

function requiredString(
  metadata: Record<string, unknown>,
  field: string,
  sourcePath: string,
) {
  const value = metadata[field]
  if (typeof value !== 'string' || value.trim() === '') {
    throw new Error(`Post ${sourcePath} requires a non-empty "${field}" field.`)
  }
  return value.trim()
}

function optionalString(
  metadata: Record<string, unknown>,
  field: string,
  sourcePath: string,
) {
  const value = metadata[field]
  if (value === undefined || value === null || value === '') return undefined
  if (typeof value !== 'string') {
    throw new Error(`Post ${sourcePath} must use a string for "${field}".`)
  }
  return value.trim()
}

function parseFrontMatter(source: string, sourcePath: string) {
  const match = source.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?([\s\S]*)$/)
  if (!match) {
    throw new Error(`Post ${sourcePath} is missing valid YAML front matter.`)
  }

  const parsed = parse(match[1])
  if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) {
    throw new Error(`Post ${sourcePath} has invalid YAML front matter.`)
  }

  const metadata = parsed as Record<string, unknown>
  const date = requiredString(metadata, 'date', sourcePath)
  if (!/^\d{4}-\d{2}-\d{2}$/.test(date) || Number.isNaN(Date.parse(date))) {
    throw new Error(
      `Post ${sourcePath} must use a valid YYYY-MM-DD value for "date".`,
    )
  }

  const tagsValue = metadata.tags
  if (
    tagsValue !== undefined &&
    (!Array.isArray(tagsValue) ||
      tagsValue.some((tag) => typeof tag !== 'string' || tag.trim() === ''))
  ) {
    throw new Error(`Post ${sourcePath} must use a string list for "tags".`)
  }

  if (metadata.draft !== undefined && typeof metadata.draft !== 'boolean') {
    throw new Error(`Post ${sourcePath} must use true or false for "draft".`)
  }

  const frontMatter: PostFrontMatter = {
    title: requiredString(metadata, 'title', sourcePath),
    description: requiredString(metadata, 'description', sourcePath),
    date,
    category: requiredString(metadata, 'category', sourcePath),
    tags: (tagsValue ?? []).map((tag) => (tag as string).trim()),
    readingTime: optionalString(metadata, 'reading_time', sourcePath),
    image: optionalString(metadata, 'image', sourcePath),
    draft: metadata.draft ?? false,
  }

  return { frontMatter, markdown: match[2].trim() }
}

function countReadingTime(markdown: string) {
  const words = markdown
    .replace(/```[\s\S]*?```/g, ' ')
    .replace(/!\[[^\]]*]\([^)]*\)/g, ' ')
    .replace(/[#>*_`[\]()|-]/g, ' ')
    .trim()
    .split(/\s+/)
    .filter(Boolean).length

  return `${Math.max(1, Math.ceil(words / 220))} min read`
}

function normalizeModulePath(path: string) {
  const parts: string[] = []
  for (const part of path.replaceAll('\\', '/').split('/')) {
    if (part === '' || part === '.') continue
    if (part === '..') {
      parts.pop()
    } else {
      parts.push(part)
    }
  }
  return `./${parts.join('/')}`
}

export function resolvePostAsset(post: Post, source?: string) {
  if (
    !source ||
    /^(?:[a-z]+:|\/|#)/i.test(source) ||
    source.startsWith('data:')
  ) {
    return source
  }

  const bundlePath = post.sourcePath.slice(0, post.sourcePath.lastIndexOf('/'))
  const suffixIndex = source.search(/[?#]/)
  const assetPath = suffixIndex === -1 ? source : source.slice(0, suffixIndex)
  const suffix = suffixIndex === -1 ? '' : source.slice(suffixIndex)
  const modulePath = normalizeModulePath(`${bundlePath}/${assetPath}`)
  const resolved = assetModules[modulePath]

  if (!resolved) {
    throw new Error(
      `Post ${post.sourcePath} references missing asset "${source}".`,
    )
  }

  return `${resolved}${suffix}`
}

function formatDate(date: string) {
  return new Intl.DateTimeFormat('en-US', {
    month: 'short',
    day: '2-digit',
    year: 'numeric',
    timeZone: 'UTC',
  }).format(new Date(`${date}T12:00:00Z`))
}

const today = new Date()
const todayIso = [
  today.getFullYear(),
  String(today.getMonth() + 1).padStart(2, '0'),
  String(today.getDate()).padStart(2, '0'),
].join('-')

const discoveredPosts = Object.entries(markdownModules)
  .filter(([sourcePath]) => !sourcePath.includes('/_template/'))
  .map(([sourcePath, source]) => {
    const { frontMatter, markdown } = parseFrontMatter(source, sourcePath)
    const bundleName = sourcePath.split('/').at(-2)
    if (!bundleName) {
      throw new Error(`Unable to derive a bundle name from ${sourcePath}.`)
    }

    const slug = bundleName.replace(/^\d{4}-\d{2}-\d{2}-/, '')
    if (!slug || slug === bundleName) {
      throw new Error(
        `Post bundle ${bundleName} must start with a YYYY-MM-DD date prefix.`,
      )
    }
    if (!bundleName.startsWith(`${frontMatter.date}-`)) {
      throw new Error(
        `Post ${sourcePath} must use the same date in its folder and front matter.`,
      )
    }

    return {
      slug,
      category: frontMatter.category,
      title: frontMatter.title,
      excerpt: frontMatter.description,
      date: formatDate(frontMatter.date),
      dateIso: frontMatter.date,
      readingTime: frontMatter.readingTime ?? countReadingTime(markdown),
      number: '',
      tags: frontMatter.tags,
      image: frontMatter.image,
      markdown,
      sourcePath,
      draft: frontMatter.draft,
    }
  })
  .filter((post) => !post.draft && post.dateIso <= todayIso)
  .sort((left, right) => right.dateIso.localeCompare(left.dateIso))

const duplicateSlug = discoveredPosts.find(
  (post, index) =>
    discoveredPosts.findIndex((candidate) => candidate.slug === post.slug) !==
    index,
)
if (duplicateSlug) {
  throw new Error(`More than one published post uses slug "${duplicateSlug.slug}".`)
}

export const posts: Post[] = discoveredPosts.map(
  ({ draft: _draft, ...post }, index) => ({
    ...post,
    image: resolvePostAsset(post, post.image),
    number: String(index + 1).padStart(2, '0'),
  }),
)

export const categories = [
  'All',
  ...new Set(posts.map((post) => post.category)),
]
