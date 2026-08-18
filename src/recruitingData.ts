export type Experience = {
  role: string
  organization: string
  period: string
  achievements: string[]
}

export const recruitingProfile = {
  name: 'Ben Martin Baur',
  role: 'AI Architect — Office of the CTO & Microsoft Innovation Hub',
  location: 'Munich, Germany',
  linkedin: 'https://www.linkedin.com/in/ben-martin-baur/',
  website: 'https://benmartinbaur.github.io/',
  summary:
    "Technology leader and delivery manager with 15+ years building, scaling, and running high-performing technical teams and communities in high-stakes enterprise environments. I've owned end-to-end delivery at scale, codified field patterns into reusable playbooks, and built teams that perform under pressure through clarity — not process. Today I design and deploy enterprise agents in production.",
  metrics: [
    { value: '15+', label: 'Years in enterprise technology' },
    { value: '75K+', label: 'Cloud PCs architected' },
    { value: '100K+', label: 'Virtual machines delivered' },
    { value: '1,200+', label: 'Cloud architects trained' },
    { value: '36', label: 'Technical experts led across EMEA' },
  ],
  skills: [
    'People Leadership at Scale',
    'Executive Stakeholder Management',
    'Enterprise AI Deployment',
    'Agent Architecture & Delivery',
    'Zero Trust / Agentic Security',
    'Field → Product Feedback Loops',
    'Technical Sales',
    'Cloud Architecture',
    'Storytelling',
  ],
  education: {
    qualification: 'Geprüfte/-r IT-Projektleiter/-in',
    institution: 'IHK Germany',
    equivalency: 'DQR / EQF Level 6 — Bachelor equivalent',
  },
  recognition: [
    'Pinnacle Award FY25',
    'Microsoft Manager Excellence Award FY24',
    'Microsoft Champion Award FY23',
    'Microsoft Gold Award FY22',
  ],
  languages: [
    { language: 'German', level: 'Native' },
    { language: 'English', level: 'Fluent' },
  ],
  experience: [
    {
      role: 'Technical Architect — Innovation Hub & Office of the CTO',
      organization: 'Microsoft Germany & Austria',
      period: 'Feb 2026 – Present',
      achievements: [
        "Lead enterprise AI transformation programs end-to-end — owning architecture direction, deployment execution, and measurable business outcomes for Microsoft's most strategic DACH customers.",
        'Deploy enterprise AI agents in production, from problem definition and envisioning to enterprise-ready architecture, integration, and Zero Trust security controls.',
        'Build reusable delivery frameworks that codify field-proven AI deployment patterns into playbooks and go-to-market assets used across the organisation.',
        'Surface early deployment signals and customer friction, translating them into structured product feedback — the field engineering to research and product loop in practice.',
      ],
    },
    {
      role: 'Senior Windows Cloud Solution Engineer',
      organization: 'Microsoft Munich',
      period: 'Jul 2025 – Feb 2026',
      achievements: [
        "Architected and delivered large-scale Windows 365 and Azure Virtual Desktop environments, including GPU workloads, for EMEA's most strategic enterprise customers.",
        'Influenced product engineering through structured customer evidence and delivered technical workshops and community engagements.',
        'Received the Microsoft Pinnacle Award FY25 — one of 42 recipients across 228,000+ employees and the top tier of the annual Platinum Club program.',
      ],
    },
    {
      role: 'Senior Manager — Azure Solution Engineers',
      organization: 'Microsoft Munich',
      period: 'Jul 2023 – Jun 2024',
      achievements: [
        'Led the Azure Solution Engineering team and created operating models and collaboration frameworks that increased alignment, reduced decision latency, and enabled faster execution.',
        'Co-founded four Azure Bootcamps across SMC EMEA and authored Well-Architected Framework, Cloud Adoption Framework, and Architecture Center documentation.',
        'Led go-to-market execution for Azure Virtual Desktop, Microsoft Dev Box, and Windows 365 in Germany and defined OKR frameworks for the pre-sales function.',
      ],
    },
    {
      role: 'Manager — Azure Advanced Cloud Experts & Cloud Solution Architects',
      organization: 'Microsoft EMEA, Ireland',
      period: 'Nov 2022 – Jul 2023',
      achievements: [
        'Reported directly to the COO of SME&C EMEA and orchestrated 36 individual contributors across EMEA with nine direct reports.',
        'Co-founded the Windows Cloud Academy, training 1,200+ Cloud Solution Architects and defining its operating model, performance standards, and delivery quality bar.',
        'Led 15+ cross-EMEA strategic initiatives, codifying field patterns into reusable playbooks and go-to-market assets.',
        'Led a 12-person Cloud Solution Architect team and built SMC Germany bridge plans that exceeded quarterly pipeline expectations.',
      ],
    },
    {
      role: 'Advanced Cloud Expert & Cloud Solution Architect',
      organization: 'Microsoft EMEA',
      period: '2020 – 2022',
      achievements: [
        "Led delivery of one of the world's largest Windows 365 and Azure Virtual Desktop environments: 75,000+ Cloud PCs and 100,000+ virtual machines, from prototype to production.",
        'Served as the voice of the customer to Microsoft engineering — an early version of the field engineering to product feedback loop.',
      ],
    },
    {
      role: 'Head of Internal IT · System Engineer',
      organization: 'RaceChip · IT-Works GmbH · HUGO BOSS',
      period: '2009 – 2019',
      achievements: [
        'Built a global WAN strategy across Germany, Hong Kong, and the United States.',
        'Spent nearly a decade in enterprise cloud, end-user computing, VDI, and Citrix, including a global retail rollout and Active Directory redesign at HUGO BOSS.',
      ],
    },
  ] satisfies Experience[],
  engineeringPosture:
    'My career started hands-on — racking servers, designing enterprise architectures and landing zones. Today I architect and design enterprise agents for production. I role-model engineering excellence by bringing deep technical clarity, connecting customers directly with the right experts, and advocating for both customer outcomes and product improvement. I help teams learn from a small number of high-impact engagements, embed customer insights into their daily rhythm, and scale those learnings across the wider organisation.',
}
