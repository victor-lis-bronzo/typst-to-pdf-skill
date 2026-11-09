// report.typ: report / long document. Cover page, table of contents,
// numbered sections, running header and page-numbered footer.
// Fill the DATA block, then replace the BODY below the show rule.
#import "base.typ": *

// ===== DATA ================================================================
#let t = theme + (accent: rgb("#1d4ed8"))
#let meta = (
  title: "Relatório de Contribuições",
  subtitle: "Commits e PRs em projetos open source — novembro de 2026",
  author: "Victor Lis Bronzo",
  org: "github.com/victor-lis-bronzo",
  date: datetime(year: 2026, month: 11, day: 8),
  lang: "pt",
  confidential: false,
  toc: true,
)

// ===== LAYOUT ==============================================================
#let report(body, meta: meta, t: t) = {
  set document(title: meta.title, author: meta.author)
  show: doc-defaults.with(t: t, lang: meta.lang)
  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    v(1.2em, weak: true)
    block(text(size: 1.45em, fill: t.accent, it))
    v(0.4em)
  }

  let date-str = meta.date.display("[day]/[month]/[year]")

  // Cover
  page(margin: 0pt, header: none, footer: none, {
    place(top + left, rect(width: 100%, height: 42%, fill: t.accent))
    place(top + left, dx: t.margin, dy: 18%, block(width: 100% - 2 * t.margin, {
      text(font: t.font-head, size: 11pt, fill: white.transparentize(20%), upper(meta.org))
      v(10pt)
      text(font: t.font-head, size: 30pt, weight: "bold", fill: white, meta.title)
      v(6pt)
      text(size: 14pt, fill: white.transparentize(10%), meta.subtitle)
    }))
    place(bottom + left, dx: t.margin, dy: -t.margin, {
      text(fill: t.ink, weight: "bold", meta.author)
      linebreak()
      text(fill: t.muted, date-str)
      if meta.confidential {
        linebreak(); v(4pt)
        pill([Confidencial], t: t)
      }
    })
  })

  // Running header/footer for the rest of the document
  set page(
    header: context {
      if counter(page).get().first() > 1 {
        set text(size: 8.5pt, fill: t.muted)
        grid(columns: (1fr, auto), meta.title, meta.org)
        v(-4pt)
        line(length: 100%, stroke: 0.5pt + t.line)
      }
    },
    footer: context {
      set text(size: 8.5pt, fill: t.muted)
      grid(columns: (1fr, auto), date-str, counter(page).display("1 / 1", both: true))
    },
  )
  counter(page).update(1)

  if meta.toc {
    outline(title: if meta.lang == "pt" { "Sumário" } else { "Contents" }, indent: auto)
    pagebreak()
  }
  body
}

#show: report.with(meta: meta, t: t)

// ===== BODY ================================================================
= Resumo

Entre 1 e 8 de novembro, o trabalho se concentrou em agentes de IA e
ferramentas de desenvolvimento: um agente de atendimento com avaliações
automatizadas, três skills para agentes e uma CLI para o Prisma.

#kpis(("50", "Commits"), ("11", "Repositórios públicos"), ("13", "PRs mesclados"), t: t)

#callout(title: "Como ler os números", kind: "warning", t: t)[
  Contagem feita pela busca de commits do GitHub (branch padrão), apenas em
  repositórios públicos. Repositórios privados ficam de fora.
]

= Atividade por repositório

== Commits no período

#data-table(
  ("Repositório", "Commits", "Do que se trata"),
  (
    ("emporio-da-musica-agent", "23", "Agente de atendimento com avaliações"),
    ("rws-skill", "8", "Skill de base de conhecimento"),
    ("typst-to-pdf-skill", "4", "Skill para gerar PDFs com Typst"),
    ("prisma-true-rollback-cli", "3", "CLI de rollback de migrations"),
    ("legal-eagle-rag-review", "2", "RAG de documentos legais no GCP"),
    ("langclips", "2", "Aprendizado de idiomas com clipes"),
    ("engineering-analogy", "2", "Visualização de engenharia de software"),
    ("clean-architecture-3d-visualizer", "2", "Clean Architecture em 3D"),
    ("harddex-landing", "2", "Landing page do Harddex"),
    ("n8n-nodes-social-preview", "1", "Node do n8n para imagens de preview"),
    ("imagine-it-skill", "1", "Skill de mockups a partir de specs"),
  ),
  columns: (2.2fr, 0.8fr, 2.6fr),
  t: t,
)

== Tipos de mudança

+ Licenças e exemplos de saída adicionados a repositórios públicos.
+ Correções na CLI do Prisma (entrada do binário, caminho do SQLite, dry-run).
+ Novos exemplos e capturas de tela nos READMEs.

= Próximos passos

- Publicar a versão 0.1.1 da CLI do Prisma no npm.
- Atualizar a seção de projetos do LinkedIn com os trabalhos do período.
- Revisar os repositórios que ainda não têm tópicos nem release.
