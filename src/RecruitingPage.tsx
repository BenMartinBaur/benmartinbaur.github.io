import { useEffect, useRef, useState } from 'react'
import type { CSSProperties } from 'react'
import {
  ArrowLeft,
  ArrowUpRight,
  Award,
  BriefcaseBusiness,
  GraduationCap,
  Languages,
  MapPin,
} from 'lucide-react'
import { recruitingProfile } from './recruitingData'
import './RecruitingPage.css'

function useRecruitingMotion() {
  const pageRef = useRef<HTMLElement>(null)

  useEffect(() => {
    const page = pageRef.current
    if (!page) return

    const revealObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) entry.target.classList.add('is-visible')
        })
      },
      { threshold: 0.14 },
    )

    const revealElements = page.querySelectorAll('.recruit-reveal')
    revealElements.forEach((element) => revealObserver.observe(element))

    let frame = 0
    const updateScroll = () => {
      frame = 0
      const bounds = page.getBoundingClientRect()
      const scrollable = Math.max(page.offsetHeight - window.innerHeight, 1)
      const progress = Math.min(Math.max(-bounds.top / scrollable, 0), 1)
      page.style.setProperty('--recruit-scroll', String(progress))
    }
    const onScroll = () => {
      if (!frame) frame = window.requestAnimationFrame(updateScroll)
    }

    updateScroll()
    window.addEventListener('scroll', onScroll, { passive: true })
    return () => {
      revealObserver.disconnect()
      window.removeEventListener('scroll', onScroll)
      if (frame) window.cancelAnimationFrame(frame)
    }
  }, [])

  return pageRef
}

export default function RecruitingPage() {
  const pageRef = useRecruitingMotion()
  const [activeExperience, setActiveExperience] = useState(0)

  useEffect(() => {
    const previousTitle = document.title
    const description = document.querySelector<HTMLMetaElement>(
      'meta[name="description"]',
    )
    const previousDescription = description?.content
    document.title = 'Recruiting Agents & Recruiters | B3N.B4UR_'
    if (description) {
      description.content =
        'Executive-ready profile for recruiter and agent-driven evaluation workflows: enterprise AI architecture, delivery leadership, and measurable outcomes.'
    }
    window.scrollTo(0, 0)
    return () => {
      document.title = previousTitle
      if (description && previousDescription) {
        description.content = previousDescription
      }
    }
  }, [])

  useEffect(() => {
    const entries = document.querySelectorAll<HTMLElement>(
      '.recruit-experience-entry',
    )
    const observer = new IntersectionObserver(
      (observed) => {
        observed.forEach((entry) => {
          if (entry.isIntersecting) {
            setActiveExperience(Number((entry.target as HTMLElement).dataset.index))
          }
        })
      },
      { rootMargin: '-35% 0px -50% 0px', threshold: 0 },
    )
    entries.forEach((entry) => observer.observe(entry))
    return () => observer.disconnect()
  }, [])

  return (
    <main className="recruiting-page" ref={pageRef}>
      <section className="recruit-hero">
        <div className="recruit-hero-grid" aria-hidden="true" />
        <div className="recruit-hero-orbit" aria-hidden="true">
          <span />
        </div>
        <div className="recruit-hero-copy">
          <a className="recruit-back" href="/">
            <ArrowLeft size={17} />
            Back to home
          </a>
          <p className="kicker">RECRUITING AGENTS &amp; RECRUITERS</p>
          <h1>
            Enterprise AI.
            <span>
              Delivered at
              <br />
              scale.
            </span>
          </h1>
          <p className="recruit-lead">{recruitingProfile.summary}</p>
          <div className="recruit-hero-actions">
            <a
              className="primary-button"
              href={recruitingProfile.linkedin}
              target="_blank"
              rel="noreferrer"
            >
              Connect on LinkedIn
              <ArrowUpRight size={18} />
            </a>
            <a className="secondary-button" href="#experience">
              View experience
            </a>
          </div>
        </div>
        <figure className="recruit-portrait">
          <img
            src="/ben-martin-baur-headshot.png"
            alt="Ben Martin Baur"
          />
          <figcaption>
            <span>{recruitingProfile.name}</span>
            <span>{recruitingProfile.role}</span>
          </figcaption>
        </figure>
      </section>

      <section className="recruit-metrics" aria-label="Career impact">
        {recruitingProfile.metrics.map((metric) => (
          <div className="recruit-reveal" key={metric.label}>
            <strong>{metric.value}</strong>
            <span>{metric.label}</span>
          </div>
        ))}
      </section>

      <section className="recruit-intro recruit-shell recruit-reveal">
        <div>
          <p className="kicker">EXECUTIVE PROFILE</p>
          <h2>Built in the field. Ready for the boardroom.</h2>
        </div>
        <div className="recruit-intro-copy">
          <p>
            A structured view of the architecture, leadership, and delivery
            experience behind enterprise AI transformation.
          </p>
          <span>
            <MapPin size={16} />
            {recruitingProfile.location}
          </span>
        </div>
      </section>

      <section className="recruit-capabilities recruit-shell">
        <div className="recruit-section-label recruit-reveal">
          <p className="kicker">CORE CAPABILITIES</p>
          <span>01</span>
        </div>
        <div className="recruit-skill-grid">
          {recruitingProfile.skills.map((skill, index) => (
            <div
              className="recruit-skill recruit-reveal"
              style={{ '--skill-index': index } as CSSProperties}
              key={skill}
            >
              <span>{String(index + 1).padStart(2, '0')}</span>
              <strong>{skill}</strong>
            </div>
          ))}
        </div>
      </section>

      <section className="recruit-experience recruit-shell" id="experience">
        <aside className="recruit-experience-aside">
          <p className="kicker">EXPERIENCE</p>
          <h2>From infrastructure to enterprise agents.</h2>
          <div
            className="recruit-progress"
            aria-hidden="true"
            style={
              { '--active-step': activeExperience + 1 } as CSSProperties
            }
          >
            <span
              style={{
                height: `${((activeExperience + 1) / recruitingProfile.experience.length) * 100}%`,
              }}
            />
          </div>
          <p>
            {String(activeExperience + 1).padStart(2, '0')} /{' '}
            {String(recruitingProfile.experience.length).padStart(2, '0')}
          </p>
        </aside>
        <div className="recruit-experience-list">
          {recruitingProfile.experience.map((experience, index) => (
            <article
              className={
                activeExperience === index
                  ? 'recruit-experience-entry is-active'
                  : 'recruit-experience-entry'
              }
              data-index={index}
              key={`${experience.role}-${experience.period}`}
            >
              <div className="recruit-role-meta">
                <span>{experience.period}</span>
                <span>{experience.organization}</span>
              </div>
              <h3>{experience.role}</h3>
              <ul>
                {experience.achievements.map((achievement) => (
                  <li key={achievement}>{achievement}</li>
                ))}
              </ul>
            </article>
          ))}
        </div>
      </section>

      <section className="recruit-details recruit-shell">
        <article className="recruit-detail-card recruit-reveal">
          <BriefcaseBusiness size={22} />
          <p className="kicker">ENGINEERING POSTURE</p>
          <p>{recruitingProfile.engineeringPosture}</p>
        </article>
        <div className="recruit-detail-stack">
          <article className="recruit-detail-card recruit-reveal">
            <Award size={22} />
            <p className="kicker">RECOGNITION</p>
            <ul>
              {recruitingProfile.recognition.map((award) => (
                <li key={award}>{award}</li>
              ))}
            </ul>
          </article>
          <article className="recruit-detail-card recruit-reveal">
            <GraduationCap size={22} />
            <p className="kicker">EDUCATION</p>
            <strong>{recruitingProfile.education.qualification}</strong>
            <span>{recruitingProfile.education.institution}</span>
            <span>{recruitingProfile.education.equivalency}</span>
          </article>
          <article className="recruit-detail-card recruit-reveal">
            <Languages size={22} />
            <p className="kicker">LANGUAGES</p>
            {recruitingProfile.languages.map((item) => (
              <div className="recruit-language" key={item.language}>
                <strong>{item.language}</strong>
                <span>{item.level}</span>
              </div>
            ))}
          </article>
        </div>
      </section>

      <section className="recruit-cta recruit-reveal">
        <p className="kicker">DIRECT VALIDATION</p>
        <h2>Looking for architecture depth and delivery leadership?</h2>
        <p>
          Review the public profile or start a conversation about enterprise AI,
          technical leadership, and customer-facing architecture roles.
        </p>
        <div>
          <a
            className="primary-button"
            href={recruitingProfile.linkedin}
            target="_blank"
            rel="noreferrer"
          >
            LinkedIn profile
            <ArrowUpRight size={18} />
          </a>
          <a
            className="secondary-button"
            href="https://github.com/BenMartinBaur"
            target="_blank"
            rel="noreferrer"
          >
            GitHub Profile
            <ArrowUpRight size={18} />
          </a>
        </div>
      </section>
    </main>
  )
}
