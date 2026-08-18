import { access, readdir, readFile } from 'node:fs/promises'
import path from 'node:path'

const distDir = path.join(process.cwd(), 'dist')

async function htmlFiles(directory) {
  const entries = await readdir(directory, { withFileTypes: true })
  const files = []
  for (const entry of entries) {
    const entryPath = path.join(directory, entry.name)
    if (entry.isDirectory()) files.push(...(await htmlFiles(entryPath)))
    if (entry.isFile() && entry.name.endsWith('.html')) files.push(entryPath)
  }
  return files
}

function targetPath(url) {
  const pathname = new URL(url, 'https://benmartinbaur.github.io').pathname
  if (pathname.endsWith('/')) return path.join(distDir, pathname, 'index.html')
  return path.join(distDir, pathname)
}

const failures = []
for (const file of await htmlFiles(distDir)) {
  const html = await readFile(file, 'utf8')
  const references = html.matchAll(/\b(?:href|src)="([^"]+)"/g)
  for (const match of references) {
    const reference = match[1]
    if (
      !reference.startsWith('/') ||
      reference.startsWith('//') ||
      reference.startsWith('/?')
    ) {
      continue
    }
    try {
      await access(targetPath(reference))
    } catch {
      failures.push(
        `${path.relative(distDir, file)} references missing ${reference}`,
      )
    }
  }
}

if (failures.length > 0) {
  throw new Error(`Broken internal references:\n${failures.join('\n')}`)
}

console.log('Verified internal links and assets in generated HTML.')

