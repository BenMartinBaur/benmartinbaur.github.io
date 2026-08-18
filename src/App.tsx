import { useEffect, useMemo, useState } from 'react'
import ReactMarkdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import {
  ArrowLeft,
  ArrowUpRight,
  BrainCircuit,
  BriefcaseBusiness,
  Moon,
  Search,
  ShieldCheck,
  Sparkles,
  Sun,
  Users,
  X,
} from 'lucide-react'
import './App.css'
import RecruitingPage from './RecruitingPage'
import { categories, posts, resolvePostAsset, type Post } from './posts'

type LegalPageData = {
  slug: 'privacy' | 'impressum'
  eyebrow: string
  title: string
  intro: string
  sections: {
    heading: string
    paragraphs?: string[]
    bullets?: string[]
  }[]
}

const legalPages: LegalPageData[] = [
  {
    slug: 'privacy',
    eyebrow: 'LEGAL / PRIVACY',
    title: 'Datenschutzerklärung',
    intro:
      'Diese Datenschutzerklärung informiert Nutzer über die Verarbeitung personenbezogener Daten bei der Nutzung dieser Website. Die gesetzlichen Regelungen zum Datenschutz gehen aus der europäischen Datenschutzgrundverordnung hervor. Das Bundesdatenschutzgesetz (BDSG) und das Telemediengesetz (TMG) gelten ergänzend. Verantwortlich für diese Website ist Ben Baur.',
    sections: [
      {
        heading: 'Personenbezogene Daten',
        paragraphs: [
          'Zu den personenbezogenen Daten zählen alle Informationen, die sich auf eine natürliche Person beziehen. Dabei kann es sich zum Beispiel um den Namen, eine Anschrift, ein Geburtsdatum oder eine E-Mail-Adresse handeln. Diese Informationen werden nur gemäß der gesetzlichen Datenschutzbestimmungen auf der Website erhoben und verarbeitet.',
        ],
      },
      {
        heading: 'Zugriffsdaten',
        paragraphs: [
          'Nutzen Sie diese Website, um sich zu informieren und geben keine Daten an, dann werden nur die Daten verarbeitet, die zur Anzeige der Website auf dem von Ihnen verwendeten Gerät erforderlich sind.',
          'Rechtsgrundlage für die Verarbeitung dieser Daten sind berechtigte Interessen gemäß Art. 6 Abs. 1 UAbs. 1 Buchstabe f DSGVO, um die Darstellung der Website grundsätzlich zu ermöglichen.',
        ],
        bullets: [
          'IP-Adresse',
          'Zeitpunkt der Anfrage',
          'Übertragene Datenmenge',
          'Quellseite',
          'Verwendeter Browser',
          'Betriebssystem',
        ],
      },
      {
        heading: 'Ihre Rechte',
        bullets: [
          'Recht auf Auskunft über die verarbeiteten personenbezogenen Daten (Art. 15 DSGVO)',
          'Recht auf Berichtigung unrichtiger oder unvollständiger Daten (Art. 16 DSGVO)',
          'Recht auf Löschung (Art. 17 DSGVO)',
          'Recht auf Einschränkung der Verarbeitung (Art. 18 DSGVO)',
          'Recht auf Datenübertragbarkeit (Art. 20 DSGVO)',
          'Widerspruchsrecht (Art. 21 DSGVO)',
          'Recht, keiner ausschließlich automatisierten Entscheidung unterworfen zu werden (Art. 22 DSGVO)',
          'Beschwerderecht bei der zuständigen Aufsichtsbehörde (Art. 77 DSGVO)',
        ],
      },
      {
        heading: 'Cookies',
        paragraphs: [
          'Diese Website verwendet derzeit keine eigenen Cookies für Tracking, Analyse oder Marketing.',
          'Sie können das Speichern von Cookies jederzeit in Ihrem Browser einschränken oder deaktivieren. Dadurch kann es in Einzelfällen zu technischen Einschränkungen bei der Darstellung von Websites kommen.',
        ],
      },
      {
        heading: 'Hosting und technische Bereitstellung',
        paragraphs: [
          'Beim Aufruf dieser Website können durch den Hosting-Anbieter technisch notwendige Verbindungsdaten verarbeitet werden, zum Beispiel IP-Adresse, Zeitpunkt der Anfrage, angeforderte Ressource sowie Browser- und Betriebssysteminformationen. Diese Verarbeitung erfolgt zur sicheren und stabilen Bereitstellung der Website.',
        ],
      },
      {
        heading: 'Kontakt',
        paragraphs: [
          'Wenn Sie per E-Mail Kontakt aufnehmen, werden die von Ihnen übermittelten Angaben ausschließlich zur Bearbeitung Ihres Anliegens verwendet.',
        ],
      },
    ],
  },
  {
    slug: 'impressum',
    eyebrow: 'LEGAL / IMPRINT',
    title: 'Impressum',
    intro: 'Angaben gemäß § 5 TMG und § 18 Abs. 2 MStV.',
    sections: [
      {
        heading: 'Inhalte der Website',
        paragraphs: [
          'Die Inhalte dieser Website werden mit größtmöglicher Sorgfalt bereitgestellt. Für Vollständigkeit, Richtigkeit und Aktualität kann keine Gewähr übernommen werden, soweit nicht ausdrücklich zugesichert. Eine Haftung ist ausgeschlossen, es sei denn, es liegt Vorsatz oder grobe Fahrlässigkeit vor.',
        ],
      },
      {
        heading: 'Verantwortlicher Anbieter',
        paragraphs: [
          'Ben Baur · Rothenfelser Str. 4 · 80249 München · Deutschland',
          'E-Mail: ben.baur@gmx.de · Website: www.benmartinbaur.github.io',
        ],
      },
      {
        heading: 'Tätigkeit',
        paragraphs: [
          'Nebenberuflich selbständiger Speaker, Moderator und Workshopleiter zu Themen rund um Künstliche Intelligenz.',
        ],
      },
      {
        heading: 'Journalistisch-redaktionelle Inhalte',
        paragraphs: [
          'Verantwortlich gemäß § 18 MStV: Ben Baur · Rothenfelser Str. 4 · 80249 München.',
        ],
      },
      {
        heading: 'Umsatzsteuer',
        paragraphs: [
          'Gemäß Anwendung der Kleinunternehmerregelung (§ 19 UStG) wird keine Umsatzsteuer ausgewiesen.',
        ],
      },
      {
        heading: 'Urheberrecht',
        paragraphs: [
          'Das Layout, Texte, verwendete Grafiken, Bilder sowie alle Beiträge auf dieser Website sind urheberrechtlich geschützt. Downloads oder Kopien dürfen nur zu privaten, nicht kommerziellen Zwecken erfolgen.',
        ],
      },
      {
        heading: 'Links zu externen Inhalten',
        paragraphs: [
          'Diese Website enthält Links zu externen Websites, für deren Inhalte Ben Baur keine Verantwortung übernimmt. Die verlinkten Inhalte stellen keine Meinungshaftung dar und dienen lediglich als Service.',
        ],
      },
      {
        heading: 'Rechtswirksamkeit',
        paragraphs: [
          'Sollten einzelne Formulierungen dieses Impressums nicht oder nicht mehr rechtlich wirksam sein, bleiben die übrigen Bestimmungen in ihrer Gültigkeit unberührt.',
        ],
      },
      {
        heading: 'Kontakt',
        paragraphs: [
          'Ben Baur · Rothenfelser Str. 4 · 80249 München · E-Mail: ben.baur@gmx.de',
        ],
      },
    ],
  },
]

function useHash() {
  const [hash, setHash] = useState(window.location.hash)

  useEffect(() => {
    const onHashChange = () => setHash(window.location.hash)
    window.addEventListener('hashchange', onHashChange)
    return () => window.removeEventListener('hashchange', onHashChange)
  }, [])

  return hash
}

function useScrollToTop(routeKey: string) {
  useEffect(() => {
    window.scrollTo({ top: 0, left: 0 })
  }, [routeKey])
}

function postHref(slug: string) {
  return `/posts/${slug}/`
}

function pageHref(page: 'privacy' | 'impressum' | 'recruiting') {
  return `/${page}/`
}

function useArticleMetadata(post: Post) {
  useEffect(() => {
    const previousTitle = document.title
    const description = document.querySelector<HTMLMetaElement>(
      'meta[name="description"]',
    )
    const previousDescription = description?.content

    document.title = `${post.title} | B3N.B4UR_`
    if (description) description.content = post.excerpt

    return () => {
      document.title = previousTitle
      if (description && previousDescription !== undefined) {
        description.content = previousDescription
      }
    }
  }, [post])
}

function Brand() {
  return (
    <a className="brand" href="/" aria-label="B3N.B4UR home">
      <span className="brand-mark">B</span>
      <span className="brand-name">B3N.B4UR_</span>
    </a>
  )
}

function GitHubIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M9 19c-4.3 1.4-4.3-2.5-6-3m12 5v-3.5c0-1 .1-1.4-.5-2 2.8-.3 5.5-1.4 5.5-6a4.6 4.6 0 0 0-1.3-3.2 4.2 4.2 0 0 0-.1-3.2s-1.1-.3-3.5 1.3a12.3 12.3 0 0 0-6.2 0C6.5 2.8 5.4 3.1 5.4 3.1a4.2 4.2 0 0 0-.1 3.2A4.6 4.6 0 0 0 4 9.5c0 4.6 2.7 5.7 5.5 6-.6.6-.6 1.2-.5 2V21"
        fill="none"
        stroke="currentColor"
        strokeLinecap="round"
        strokeLinejoin="round"
        strokeWidth="2"
      />
    </svg>
  )
}

function LinkedInIcon() {
  return (
    <svg viewBox="0 0 24 24" aria-hidden="true">
      <path
        d="M19 3a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h14M8.34 17v-6.05H6.31V17h2.03M7.32 10.11a1.18 1.18 0 1 0 0-2.36 1.18 1.18 0 0 0 0 2.36M17.69 17v-3.31c0-1.77-.94-2.74-2.19-2.74-1 0-1.45.55-1.7.94v-.94h-2.04V17h2.04v-3.37c0-.89.32-1.76 1.43-1.76 1.09 0 1.11 1.02 1.11 1.82V17h1.35Z"
        fill="currentColor"
      />
    </svg>
  )
}

function Header() {
  const [searchOpen, setSearchOpen] = useState(false)
  const [query, setQuery] = useState('')
  const [theme, setTheme] = useState(
    document.documentElement.getAttribute('data-theme') ?? 'light',
  )

  const toggleTheme = () => {
    const next = theme === 'dark' ? 'light' : 'dark'
    document.documentElement.setAttribute('data-theme', next)
    window.localStorage.setItem('ben-theme', next)
    setTheme(next)
  }

  useEffect(() => {
    if (!searchOpen) return
    const close = (event: KeyboardEvent) => {
      if (event.key === 'Escape') setSearchOpen(false)
    }
    window.addEventListener('keydown', close)
    return () => window.removeEventListener('keydown', close)
  }, [searchOpen])

  const searchResults = posts.filter((post) =>
    `${post.title} ${post.excerpt} ${post.category}`
      .toLowerCase()
      .includes(query.toLowerCase()),
  )

  return (
    <>
      <header className="site-header">
        <div className="header-inner">
          <Brand />
          <nav className="utility-nav" aria-label="Utility navigation">
            <button
              className="nav-icon"
              type="button"
              onClick={() => setSearchOpen(true)}
              aria-label="Search articles"
            >
              <Search />
            </button>
            <button
              className="nav-icon"
              type="button"
              onClick={toggleTheme}
              aria-label={`Switch to ${theme === 'dark' ? 'light' : 'dark'} theme`}
            >
              {theme === 'dark' ? <Sun /> : <Moon />}
            </button>
            <a
              className="nav-icon ai-link"
              href="https://chatgpt.com/?q=Summarize+Ben+Martin+Baur%27s+background%2C+leadership+style%2C+and+core+technology+themes+from+public+sources."
              target="_blank"
              rel="noreferrer"
              aria-label="Ask AI about Ben Martin Baur"
            >
              AI
            </a>
            <a
              className="nav-icon"
              href="https://github.com/benmartinbaur"
              target="_blank"
              rel="noreferrer"
              aria-label="GitHub"
            >
              <GitHubIcon />
            </a>
            <a
              className="nav-icon"
              href="https://www.linkedin.com/in/ben-martin-baur/"
              target="_blank"
              rel="noreferrer"
              aria-label="LinkedIn"
            >
              <LinkedInIcon />
            </a>
          </nav>
        </div>
      </header>
      {searchOpen && (
        <div
          className="search-overlay"
          role="dialog"
          aria-modal="true"
          aria-label="Search articles"
        >
          <button
            className="search-backdrop"
            type="button"
            onClick={() => setSearchOpen(false)}
            aria-label="Close search"
          />
          <div className="search-panel">
            <div className="search-field">
              <Search size={22} />
              <input
                autoFocus
                type="search"
                value={query}
                onChange={(event) => setQuery(event.target.value)}
                placeholder="Search articles..."
                aria-label="Search articles"
              />
              <button
                type="button"
                onClick={() => setSearchOpen(false)}
                aria-label="Close search"
              >
                <X size={20} />
              </button>
            </div>
            <div className="search-results">
              {searchResults.map((post) => (
                <a
                  href={postHref(post.slug)}
                  key={post.slug}
                  onClick={() => setSearchOpen(false)}
                >
                  <span>{post.category}</span>
                  <strong>{post.title}</strong>
                  <p>{post.excerpt}</p>
                </a>
              ))}
              {searchResults.length === 0 && (
                <p className="no-results">No articles match “{query}”.</p>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  )
}

function Hero() {
  const [activeTopic, setActiveTopic] = useState<number | null>(null)
  const topics = [
    {
      label: 'AI Architecture',
      detail:
        'that turns emerging capabilities into secure, scalable systems.',
    },
    {
      label: 'Career Development',
      detail:
        'through deliberate learning, visible impact, and better choices.',
    },
    {
      label: 'Leadership',
      detail: 'that creates clarity, trust, and momentum through change.',
    },
  ]

  return (
    <section className="hero" id="top">
      <div className="hero-content">
        <h1>
          <span>Be.</span>
          <span>Extrodenary.</span>
          <span>Now.</span>
        </h1>
        <div className="hero-actions">
          <a className="primary-button" href="#writing">
            Read the blog
          </a>
          <a className="secondary-button" href="#about">
            About me
          </a>
        </div>
      </div>
      <div
        className="triangle-scene"
        aria-hidden="true"
      >
        <svg className="hero-triangle" viewBox="0 0 100 88">
          <defs>
            <filter
              id="triangle-glow"
              x="-100%"
              y="-100%"
              width="300%"
              height="300%"
              colorInterpolationFilters="sRGB"
            >
              <feGaussianBlur
                in="SourceAlpha"
                stdDeviation="3"
                result="near-blur"
              />
              <feOffset
                in="near-blur"
                dx="4"
                dy="1"
                result="near-offset"
              />
              <feFlood
                floodColor="currentColor"
                floodOpacity="0.98"
                result="near-color"
              />
              <feComposite
                in="near-color"
                in2="near-offset"
                operator="in"
                result="near-glow"
              />

              <feGaussianBlur
                in="SourceAlpha"
                stdDeviation="10"
                result="mid-blur"
              />
              <feOffset
                in="mid-blur"
                dx="10"
                dy="2"
                result="mid-offset"
              />
              <feFlood
                floodColor="currentColor"
                floodOpacity="0.62"
                result="mid-color"
              />
              <feComposite
                in="mid-color"
                in2="mid-offset"
                operator="in"
                result="mid-glow"
              />

              <feGaussianBlur
                in="SourceAlpha"
                stdDeviation="22"
                result="wide-blur"
              />
              <feOffset
                in="wide-blur"
                dx="18"
                dy="4"
                result="wide-offset"
              />
              <feFlood
                floodColor="currentColor"
                floodOpacity="0.3"
                result="wide-color"
              />
              <feComposite
                in="wide-color"
                in2="wide-offset"
                operator="in"
                result="wide-glow"
              />

              <feMerge>
                <feMergeNode in="wide-glow" />
                <feMergeNode in="mid-glow" />
                <feMergeNode in="near-glow" />
                <feMergeNode in="SourceGraphic" />
              </feMerge>
            </filter>
          </defs>
          <polygon
            points="50,2 98,86 2,86"
            fill="var(--cp-triangle)"
            filter="url(#triangle-glow)"
          />
        </svg>
      </div>
      <div
        className="hero-copy"
        onMouseLeave={() => setActiveTopic(null)}
        onBlur={(event) => {
          if (!event.currentTarget.contains(event.relatedTarget)) {
            setActiveTopic(null)
          }
        }}
      >
        {topics.map((topic, index) => (
          <button
            className={activeTopic === index ? 'topic-active' : ''}
            type="button"
            key={topic.label}
            onMouseEnter={() => setActiveTopic(index)}
            onFocus={() => setActiveTopic(index)}
            onClick={() =>
              setActiveTopic((current) => (current === index ? null : index))
            }
          >
            <strong>{topic.label}</strong>
            {activeTopic === index && <span> {topic.detail}</span>}
          </button>
        ))}
      </div>
    </section>
  )
}

function Writing() {
  const [filter, setFilter] = useState('All')
  const visiblePosts = useMemo(
    () =>
      filter === 'All'
        ? posts
        : posts.filter((post) => post.category === filter),
    [filter],
  )

  const categoryIcon = (category: string) => {
    if (category === 'AI Architecture') return <BrainCircuit size={18} />
    if (category === 'Career') return <BriefcaseBusiness size={18} />
    if (category === 'Leadership') return <Users size={18} />
    return <Sparkles size={18} />
  }

  return (
    <section className="writing section-shell" id="writing">
      <div className="section-heading">
        <div>
          <p className="kicker">THE LATEST</p>
          <h2>Notes from the edge of change.</h2>
        </div>
        <p>
          Field notes, practical patterns, and honest reflections for ambitious
          humans working with intelligent machines.
        </p>
      </div>
      <div className="filters" aria-label="Filter posts by category">
        {categories.map((category) => (
          <button
            className={filter === category ? 'filter-active' : ''}
            key={category}
            type="button"
            onClick={() => setFilter(category)}
          >
            {category}
          </button>
        ))}
      </div>
      <div className="post-grid">
        {visiblePosts.map((post) => (
          <article className="post-card" key={post.slug}>
            <div className="post-card-top">
              <span>{post.number}</span>
              <span className="category-icon">
                {categoryIcon(post.category)}
              </span>
            </div>
            <div className="post-meta">
              <span>{post.category}</span>
              <span>{post.readingTime}</span>
            </div>
            <h3>{post.title}</h3>
            <p>{post.excerpt}</p>
            <a href={postHref(post.slug)}>
              Read article
              <ArrowUpRight size={17} />
            </a>
          </article>
        ))}
      </div>
    </section>
  )
}

function About() {
  const aboutPost = posts.find((post) => post.slug === 'about-ben-martin-baur')

  return (
    <section className="about section-shell" id="about">
      <div className="about-number">B/E/N</div>
      <div className="about-copy">
        <p className="kicker">ABOUT</p>
        <h2>Architecture is about people.</h2>
        <p>
          I am an AI Architect in the Office of the CTO and Microsoft
          Innovation Hub. My work sits where emerging technology meets real
          human ambition.
        </p>
        <p>
          This is where I share what I am learning: patterns for responsible AI
          systems, ways to navigate a career with intention, and leadership
          practices that help people do extraordinary work.
        </p>
        {aboutPost && (
          <a className="about-link" href={postHref(aboutPost.slug)}>
            Learn more about me
            <ArrowUpRight size={17} />
          </a>
        )}
      </div>
    </section>
  )
}

function Footer() {
  return (
    <footer id="connect">
      <div className="footer-cta">
        <p className="kicker">LET'S CONNECT</p>
        <h2>Build something extraordinary.</h2>
        <a
          href="https://www.linkedin.com/in/ben-martin-baur/"
          target="_blank"
          rel="noreferrer"
        >
          Start a conversation
          <ArrowUpRight size={18} />
        </a>
      </div>
      <div className="footer-bottom">
        <div className="footer-brand-column">
          <Brand />
          <nav aria-label="Legal and recruiting">
            <a href={pageHref('privacy')}>Privacy</a>
            <a href={pageHref('impressum')}>Impressum</a>
            <a
              href={pageHref('recruiting')}
            >
              Recruiting Agents &amp; Recruiters
            </a>
          </nav>
        </div>
        <p>Ideas on AI, career development, and leadership.</p>
        <div className="social-links">
          <a
            href="https://www.linkedin.com/in/ben-martin-baur/"
            aria-label="LinkedIn"
          >
            <LinkedInIcon />
          </a>
          <a href="https://github.com/benmartinbaur" aria-label="GitHub">
            <GitHubIcon />
          </a>
        </div>
      </div>
      <div className="footer-trust">
        <ShieldCheck size={15} />
        <span>No tracking or analytics cookies are used on this site.</span>
      </div>
    </footer>
  )
}

function LegalPage({ page }: { page: LegalPageData }) {
  useScrollToTop(page.slug)

  return (
    <main className="legal-page">
      <section className="legal-hero">
        <div className="legal-grid" aria-hidden="true" />
        <div className="legal-geometry" aria-hidden="true">
          <span />
        </div>
        <div className="legal-hero-content">
          <a className="back-link" href="/">
            <ArrowLeft size={17} />
            Back to home
          </a>
          <p className="kicker">{page.eyebrow}</p>
          <h1>{page.title}</h1>
          <p>{page.intro}</p>
        </div>
      </section>
      <article className="legal-content">
        {page.sections.map((section, index) => (
          <section key={section.heading}>
            <span className="legal-index">
              {String(index + 1).padStart(2, '0')}
            </span>
            <div>
              <h2>{section.heading}</h2>
              {section.paragraphs?.map((paragraph) => (
                <p key={paragraph}>{paragraph}</p>
              ))}
              {section.bullets && (
                <ul>
                  {section.bullets.map((bullet) => (
                    <li key={bullet}>{bullet}</li>
                  ))}
                </ul>
              )}
            </div>
          </section>
        ))}
      </article>
      <Footer />
    </main>
  )
}

function PostPage({ post }: { post: Post }) {
  useScrollToTop(post.slug)
  useArticleMetadata(post)

  return (
    <main className="article-page">
      <div className="article-hero">
        <a className="back-link" href="/#writing">
          <ArrowLeft size={17} />
          All writing
        </a>
        <p className="kicker">{post.category}</p>
        <h1>{post.title}</h1>
        <p className="article-intro">{post.excerpt}</p>
        <div className="article-meta">
          <span>{post.date}</span>
          <span>{post.readingTime}</span>
        </div>
        {post.tags.length > 0 && (
          <div className="article-tags" aria-label="Article tags">
            {post.tags.map((tag) => (
              <span key={tag}>{tag}</span>
            ))}
          </div>
        )}
      </div>
      <article className="article-body">
        {post.image && (
          <img className="article-featured-image" src={post.image} alt="" />
        )}
        <ReactMarkdown
          remarkPlugins={[remarkGfm]}
          components={{
            a({ href, children, ...props }) {
              const external = Boolean(href && /^https?:\/\//i.test(href))
              return (
                <a
                  {...props}
                  href={href}
                  target={external ? '_blank' : undefined}
                  rel={external ? 'noreferrer' : undefined}
                >
                  {children}
                </a>
              )
            },
            img({ src, alt, ...props }) {
              return (
                <img
                  {...props}
                  src={resolvePostAsset(post, src)}
                  alt={alt ?? ''}
                  loading="lazy"
                />
              )
            },
            pre({ children, ...props }) {
              return (
                <pre {...props} tabIndex={0}>
                  {children}
                </pre>
              )
            },
          }}
        >
          {post.markdown}
        </ReactMarkdown>
        <div className="article-note">
          <Sparkles size={20} />
          <p>
            Be curious. Make the next decision visible. Learn in the open.
          </p>
        </div>
      </article>
      <Footer />
    </main>
  )
}

function App() {
  const hash = useHash()
  const normalizedPath =
    window.location.pathname
      .replace(/\/index\.html$/, '')
      .replace(/\/+$/, '') || '/'
  const pathPostSlug = normalizedPath.match(/^\/posts\/([^/]+)$/)?.[1] ?? null
  const pathPage = normalizedPath.match(
    /^\/(privacy|impressum|recruiting)$/,
  )?.[1]
  const pageParam = new URLSearchParams(window.location.search).get('page')
  const postParam = new URLSearchParams(window.location.search).get('post')
  const postSlug =
    pathPostSlug ??
    postParam ??
    (hash.startsWith('#post/') ? hash.replace('#post/', '') : null)
  const selectedPost = posts.find((post) => post.slug === postSlug)
  const selectedLegalPage = legalPages.find(
    (page) =>
      pathPage === page.slug ||
      pageParam === page.slug ||
      hash === `#${page.slug}`,
  )
  const selectedRecruitingPage =
    pathPage === 'recruiting' || pageParam === 'recruiting'

  return (
    <>
      <Header />
      {selectedPost ? (
        <PostPage post={selectedPost} />
      ) : selectedRecruitingPage ? (
        <>
          <RecruitingPage />
          <Footer />
        </>
      ) : selectedLegalPage ? (
        <LegalPage page={selectedLegalPage} />
      ) : (
        <main>
          <Hero />
          <Writing />
          <About />
          <Footer />
        </main>
      )}
    </>
  )
}

export default App
