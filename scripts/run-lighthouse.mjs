import { access, mkdir, readFile } from 'node:fs/promises'
import { spawn } from 'node:child_process'
import path from 'node:path'
import { chromium } from '@playwright/test'

const root = process.cwd()
const port = 4176
const baseUrl = `http://127.0.0.1:${port}`
const outputDir = path.join(root, '.quality', 'lighthouse')
const routes = [
  ['home', '/'],
  ['article', '/posts/about-ben-martin-baur/'],
  ['privacy', '/privacy/'],
  ['recruiting', '/recruiting/'],
]
const budgets = {
  performance: 0.95,
  accessibility: 1,
  'best-practices': 1,
  seo: 1,
  'first-contentful-paint': 1800,
  'largest-contentful-paint': 2500,
  'total-blocking-time': 200,
  'cumulative-layout-shift': 0.1,
}

function waitForServer(url, timeoutMs = 30_000) {
  const started = Date.now()
  return new Promise((resolve, reject) => {
    const check = async () => {
      try {
        const response = await fetch(url)
        if (response.ok) return resolve()
      } catch {
        // The preview process is still starting.
      }
      if (Date.now() - started >= timeoutMs) {
        return reject(new Error(`Preview server did not start at ${url}.`))
      }
      setTimeout(check, 250)
    }
    check()
  })
}

function run(command, args, options = {}) {
  return new Promise((resolve) => {
    const child = spawn(command, args, {
      cwd: root,
      stdio: 'inherit',
      ...options,
    })
    child.on('exit', (code) => resolve(code ?? 1))
  })
}

const vitePath = path.join(root, 'node_modules', 'vite', 'bin', 'vite.js')
const preview = spawn(
  process.execPath,
  [vitePath, 'preview', '--host', '127.0.0.1', '--port', String(port)],
  { cwd: root, stdio: 'ignore' },
)

try {
  await waitForServer(baseUrl)
  await mkdir(outputDir, { recursive: true })

  const environment = { ...process.env }
  if (!environment.CHROME_PATH) {
    if (process.platform === 'win32') {
      const edge =
        'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe'
      try {
        await access(edge)
        environment.CHROME_PATH = edge
      } catch {
        throw new Error(
          'Set CHROME_PATH to a Chromium-based browser.',
        )
      }
    } else {
      try {
        const playwrightChromium = chromium.executablePath()
        await access(playwrightChromium)
        environment.CHROME_PATH = playwrightChromium
      } catch {
        throw new Error(
          'Install Playwright Chromium or set CHROME_PATH to a Chromium browser.',
        )
      }
    }
  }

  const failures = []
  const lighthouseCli = path.join(
    root,
    'node_modules',
    'lighthouse',
    'cli',
    'index.js',
  )
  for (const [name, route] of routes) {
    const reportPath = path.join(outputDir, `${name}.json`)
    const exitCode = await run(
      process.execPath,
      [
        lighthouseCli,
        `${baseUrl}${route}`,
        '--output=json',
        `--output-path=${reportPath}`,
        '--quiet',
        '--chrome-flags=--headless --disable-gpu --no-first-run --no-sandbox',
      ],
      { env: environment },
    )
    try {
      await access(reportPath)
    } catch {
      throw new Error(
        `Lighthouse failed for ${name} with exit code ${exitCode} and produced no report.`,
      )
    }
    if (exitCode !== 0) {
      console.warn(
        `Lighthouse exited with code ${exitCode} for ${name}, but the report was generated.`,
      )
    }

    const report = JSON.parse(await readFile(reportPath, 'utf8'))
    for (const category of [
      'performance',
      'accessibility',
      'best-practices',
      'seo',
    ]) {
      const score = report.categories[category].score
      if (score < budgets[category]) {
        failures.push(
          `${name}: ${category} ${Math.round(score * 100)} < ${budgets[category] * 100}`,
        )
      }
    }
    for (const audit of [
      'first-contentful-paint',
      'largest-contentful-paint',
      'total-blocking-time',
      'cumulative-layout-shift',
    ]) {
      const value = report.audits[audit].numericValue
      if (value > budgets[audit]) {
        failures.push(`${name}: ${audit} ${value} > ${budgets[audit]}`)
      }
    }
  }

  if (failures.length > 0) {
    throw new Error(`Lighthouse budgets failed:\n${failures.join('\n')}`)
  }
  console.log(`Lighthouse budgets passed for ${routes.length} routes.`)
} finally {
  preview.kill()
}
