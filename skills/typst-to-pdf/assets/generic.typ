// generic.typ: minimal starting point for free-form / bespoke documents.
// Keep the DATA / LAYOUT / BODY split so later edits stay easy.
// See references/freeform.md for how to design from here.
#import "base.typ": *

// ===== DATA ================================================================
#let t = theme + (accent: rgb("#1d4ed8"))
#let meta = (
  title: "Título do documento",
  author: "Autor",
  lang: "pt",
  paper: "a4", // "a4" | "us-letter" | "a5" | ... or use width/height in #set page
  date: datetime.today(),
)

// ===== LAYOUT ==============================================================
#set document(title: meta.title, author: meta.author)
#show: doc-defaults.with(t: t, lang: meta.lang, paper: meta.paper)
#set heading(numbering: none)
#show heading.where(level: 1): set text(size: 1.6em, fill: t.accent)
#set page(footer: context align(center, text(size: 8.5pt, fill: t.muted,
  counter(page).display("1 / 1", both: true))))

// ===== BODY ================================================================
= #meta.title
#text(fill: t.muted)[#meta.author · #meta.date.display("[day]/[month]/[year]")]

#divider(t: t)

Conteúdo aqui. Use `#callout`, `#kpis`, `#data-table`, `#pill` e `#money`
de `base.typ`, ou crie componentes próprios neste arquivo.
