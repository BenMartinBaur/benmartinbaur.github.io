import AxeBuilder from '@axe-core/playwright'
import { expect, test } from '@playwright/test'

const routes = [
  {
    path: '/',
    title: 'B3N.B4UR_ — Be. Extrodenary. Now.',
    heading: 'Be.',
  },
  {
    path: '/posts/about-ben-martin-baur/',
    title: 'About Ben Martin Baur | B3N.B4UR_',
    heading: 'About Ben Martin Baur',
  },
  {
    path: '/posts/building-an-industry-standard-github-pages-blog/',
    title: 'Building an Industry-Standard Blog on GitHub Pages | B3N.B4UR_',
    heading: 'Building an Industry-Standard Blog on GitHub Pages',
  },
  {
    path: '/privacy/',
    title: 'Privacy | B3N.B4UR_',
    heading: 'Datenschutzerklärung',
  },
  {
    path: '/impressum/',
    title: 'Impressum | B3N.B4UR_',
    heading: 'Impressum',
  },
  {
    path: '/recruiting/',
    title: 'Recruiting Agents & Recruiters | B3N.B4UR_',
    heading: 'Enterprise AI.',
  },
]

for (const route of routes) {
  test(`${route.path} renders its canonical page`, async ({ page }) => {
    await page.goto(route.path)
    await expect(page).toHaveTitle(route.title)
    await expect(page.getByRole('heading', { level: 1 })).toContainText(
      route.heading,
    )
    await expect(page.locator('link[rel="canonical"]')).toHaveAttribute(
      'href',
      `https://benmartinbaur.github.io${route.path}`,
    )
  })
}

test('home and search link to canonical article routes', async ({ page }) => {
  await page.goto('/')
  const articleLink = page.getByRole('link', { name: 'Read article' }).first()
  await expect(articleLink).toHaveAttribute('href', /^\/posts\/[^/]+\/$/)

  await page.getByRole('button', { name: 'Search articles' }).click()
  await page.getByRole('searchbox', { name: 'Search articles' }).fill('clarity')
  const result = page.getByRole('link', { name: /Lead through clarity/ })
  await expect(result).toHaveAttribute('href', '/posts/lead-through-clarity/')
  await page.keyboard.press('Escape')
  await expect(page.getByRole('dialog')).toBeHidden()
})

test('legacy query routes remain compatible', async ({ page }) => {
  await page.goto('/?post=about-ben-martin-baur')
  await expect(
    page.getByRole('heading', { level: 1, name: 'About Ben Martin Baur' }),
  ).toBeVisible()

  await page.goto('/?page=privacy')
  await expect(
    page.getByRole('heading', { level: 1, name: 'Datenschutzerklärung' }),
  ).toBeVisible()
})

test('theme selection persists after reload', async ({ page }) => {
  await page.goto('/')
  await page
    .getByRole('button', { name: 'Switch to light theme' })
    .click()
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'light')
  await page.reload()
  await expect(page.locator('html')).toHaveAttribute('data-theme', 'light')
})

for (const route of routes) {
  test(`${route.path} has no serious accessibility violations`, async ({
    page,
  }) => {
    await page.goto(route.path)
    const results = await new AxeBuilder({ page }).analyze()
    const blocking = results.violations.filter(
      (violation) =>
        violation.impact === 'critical' || violation.impact === 'serious',
    )
    expect(blocking).toEqual([])
  })

  test(`${route.path} does not overflow a mobile viewport`, async ({ page }) => {
    await page.setViewportSize({ width: 390, height: 844 })
    await page.goto(route.path)
    const overflow = await page.evaluate(
      () => document.documentElement.scrollWidth - window.innerWidth,
    )
    expect(overflow).toBeLessThanOrEqual(1)
  })
}
