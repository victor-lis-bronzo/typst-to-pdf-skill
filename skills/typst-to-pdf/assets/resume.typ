// resume.typ: résumé / CV, 1–2 pages. Sidebar with contact and skills,
// main column with experience and education. Everything comes from `cv`.
#import "base.typ": *

// ===== DATA ================================================================
#let t = theme + (accent: rgb("#0f766e"), margin: 1.6cm, size: 10pt)
#let cv = (
  name: "Mariana Souza",
  role: "Engenheira de Software Backend",
  lang: "pt",
  contact: (
    "mariana.souza@email.com",
    "+55 11 98765-4321",
    "São Paulo, SP",
    "linkedin.com/in/marianasouza",
    "github.com/marianasouza",
  ),
  summary: [Engenheira backend com 7 anos de experiência em sistemas distribuídos,
    APIs de alto volume e pagamentos. Gosto de simplificar arquiteturas e de
    medir antes de otimizar.],
  skills: (
    ("Linguagens", ("Go", "Python", "TypeScript", "SQL")),
    ("Infra", ("AWS", "Kubernetes", "Terraform", "PostgreSQL", "Kafka")),
    ("Práticas", ("DDD", "Observabilidade", "Code review", "Mentoria")),
  ),
  languages: (("Português", "nativo"), ("Inglês", "fluente"), ("Espanhol", "intermediário")),
  experience: (
    (
      role: "Engenheira de Software Sênior",
      org: "PagaFácil",
      period: "2022 – atual",
      bullets: (
        [Liderou a migração do motor de cobrança para Go, reduzindo a latência p99 de 820 ms para 140 ms.],
        [Desenhou a reconciliação de pagamentos via Kafka, processando 3 milhões de eventos por dia.],
        [Mentora de 4 pessoas desenvolvedoras; duas promovidas no período.],
      ),
    ),
    (
      role: "Engenheira de Software",
      org: "Loggi",
      period: "2019 – 2022",
      bullets: (
        [Criou a API de rastreio usada por 40 mil lojistas, com SLA de 99,95%.],
        [Reduziu em 35% o custo de infraestrutura com autoscaling e revisão de queries.],
      ),
    ),
  ),
  education: (
    (title: "Bacharelado em Ciência da Computação", org: "USP", period: "2014 – 2018"),
  ),
)

// ===== LAYOUT ==============================================================
#let section(title) = {
  v(14pt, weak: true)
  text(font: t.font-head, size: 9pt, weight: "bold", fill: t.accent, tracking: 1.2pt, upper(title))
  v(-4pt)
  line(length: 100%, stroke: 0.6pt + t.line)
  v(2pt)
}

#set document(title: cv.name + " — " + cv.role, author: cv.name)
#show: doc-defaults.with(t: t, lang: cv.lang)
#set par(justify: false)

#grid(
  columns: (1fr, auto),
  align: (left + bottom, right + bottom),
  {
    text(font: t.font-head, size: 24pt, weight: "bold", cv.name)
    linebreak()
    text(size: 12pt, fill: t.accent, cv.role)
  },
)
#v(4pt)
#line(length: 100%, stroke: 1.5pt + t.accent)
#v(6pt)

#grid(
  columns: (32%, 1fr),
  column-gutter: 18pt,
  // Sidebar
  {
    section("Contato")
    set text(size: 9pt)
    for c in cv.contact [#c \ ]
    section("Competências")
    for (group, items) in cv.skills {
      text(weight: "bold", size: 9pt, group)
      linebreak()
      items.map(i => pill(i, t: t)).join(h(3pt))
      v(6pt)
    }
    section("Idiomas")
    set text(size: 9pt)
    for (l, lvl) in cv.languages [*#l* — #lvl \ ]
  },
  // Main column
  {
    section("Resumo")
    cv.summary
    section("Experiência")
    for job in cv.experience {
      grid(
        columns: (1fr, auto),
        text(weight: "bold", job.role) + [ · ] + text(fill: t.accent, job.org),
        text(size: 9pt, fill: t.muted, job.period),
      )
      v(2pt)
      list(..job.bullets)
      v(6pt)
    }
    section("Formação")
    for e in cv.education {
      grid(
        columns: (1fr, auto),
        text(weight: "bold", e.title) + [ · ] + e.org,
        text(size: 9pt, fill: t.muted, e.period),
      )
    }
  },
)
