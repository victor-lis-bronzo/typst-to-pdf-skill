// report.typ: report / long document. Cover page, table of contents,
// numbered sections, running header and page-numbered footer.
// Fill the DATA block, then replace the BODY below the show rule.
#import "base.typ": *

// ===== DATA ================================================================
#let t = theme + (accent: rgb("#1d4ed8"))
#let meta = (
  title: "Relatório Trimestral de Operações",
  subtitle: "Resultados do 3º trimestre de 2026",
  author: "Equipe de Operações",
  org: "Waywize Logística",
  date: datetime(year: 2026, month: 10, day: 15),
  lang: "pt",
  confidential: true,
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
= Resumo executivo

O trimestre fechou acima da meta em volume entregue e prazo médio, com
pressão de custo no frete de última milha. As ações de roteirização dinâmica
reduziram o tempo médio de entrega em 11%.

#kpis(("18.420", "Entregas no trimestre"), ("96,4%", "No prazo"), ("2,1 dias", "Prazo médio"), t: t)

#callout(title: "Ponto de atenção", kind: "warning", t: t)[
  O custo por entrega na região Sul subiu 7% devido ao reajuste dos
  parceiros terceirizados. Renegociação prevista para novembro.
]

= Resultados por região

== Volume e nível de serviço

#data-table(
  ("Região", "Entregas", "No prazo", "Custo médio"),
  (
    ("Sudeste", "9.870", "97,2%", money(18.4)),
    ("Sul", "4.110", "95,1%", money(22.9)),
    ("Nordeste", "2.960", "95,8%", money(24.3)),
    ("Centro-Oeste", "1.480", "96,0%", money(21.7)),
  ),
  columns: (2fr, 1fr, 1fr, 1fr),
  t: t,
)

== Principais causas de atraso

+ Endereço incompleto ou divergente no pedido (38% dos casos).
+ Ausência do destinatário na primeira tentativa (31%).
+ Restrições de circulação em áreas centrais (17%).

= Próximos passos

- Validação de endereço no checkout, com integração ao serviço de CEP.
- Janela de entrega agendada para clientes recorrentes.
- Revisão dos contratos de última milha na região Sul.
