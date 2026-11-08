// proposal.typ: commercial proposal / quote / invoice. Company header,
// client block, line items with computed totals, terms and signature.
// Set `doc.kind` to "proposal" or "invoice"; totals are computed from `items`.
#import "base.typ": *

// ===== DATA ================================================================
#let t = theme + (accent: rgb("#7c3aed"))
#let doc = (
  kind: "proposal", // "proposal" | "invoice"
  number: "PROP-2026-0187",
  date: datetime(year: 2026, month: 11, day: 8),
  valid-days: 15,
  lang: "pt",
  currency: "R$",
  logo: none, // e.g. "logo.png" (path relative to this file)
  from: (
    name: "Waywize Tecnologia Ltda",
    id: "CNPJ 12.345.678/0001-90",
    address: "Av. Paulista, 1000 — São Paulo, SP",
    contact: "contato@waywize.com.br · (11) 3000-0000",
  ),
  to: (
    name: "Padaria Pão Dourado",
    id: "CNPJ 98.765.432/0001-10",
    address: "Rua das Flores, 250 — Campinas, SP",
    contact: "Ana Lima · ana@paodourado.com.br",
  ),
  intro: [Conforme conversado, segue proposta para o desenvolvimento do sistema
    de pedidos online com retirada na loja e integração ao PDV atual.],
  items: (
    // (description, quantity, unit price)
    ("Descoberta e protótipo navegável", 1, 4800),
    ("Loja online (catálogo, carrinho, retirada)", 1, 18500),
    ("Integração com PDV", 1, 6200),
    ("Hospedagem e suporte mensal", 12, 690),
  ),
  discount: 0.05, // fraction of subtotal; 0 for none
  tax: 0,         // fraction of (subtotal - discount); 0 for none
  terms: (
    [Pagamento: 40% na aprovação, 30% na entrega do protótipo, 30% no go-live.],
    [Prazo estimado: 10 semanas após a aprovação.],
    [Valores de suporte reajustados anualmente pelo IPCA.],
  ),
  signer: (name: "Victor Lis", role: "Diretor de Projetos"),
)

// ===== LAYOUT ==============================================================
#let m(x) = money(x, symbol: doc.currency)
#let subtotal = doc.items.map(((_, q, p)) => q * p).sum()
#let discount = subtotal * doc.discount
#let tax = (subtotal - discount) * doc.tax
#let total = subtotal - discount + tax
#let title = if doc.kind == "invoice" { "Fatura" } else { "Proposta Comercial" }

#set document(title: title + " " + doc.number, author: doc.from.name)
#show: doc-defaults.with(t: t, lang: doc.lang)
#set page(footer: context {
  set text(size: 8pt, fill: t.muted)
  grid(columns: (1fr, auto), doc.from.name + " · " + doc.from.contact, counter(page).display("1/1", both: true))
})

#grid(
  columns: (1fr, auto),
  align: (left + horizon, right + horizon),
  if doc.logo != none { image(doc.logo, height: 1.4cm) } else {
    text(font: t.font-head, size: 16pt, weight: "bold", fill: t.accent, doc.from.name)
  },
  {
    text(font: t.font-head, size: 18pt, weight: "bold", title)
    linebreak()
    text(fill: t.muted, doc.number + " · " + doc.date.display("[day]/[month]/[year]"))
  },
)
#v(4pt)
#line(length: 100%, stroke: 2pt + t.accent)
#v(10pt)

#let party(label, p) = block(width: 100%, inset: 10pt, radius: 4pt, fill: t.subtle, {
  text(size: 8pt, weight: "bold", fill: t.accent, tracking: 1pt, upper(label))
  linebreak()
  text(weight: "bold", p.name)
  linebreak()
  set text(size: 9pt, fill: t.muted)
  [#p.id \ #p.address \ #p.contact]
})
#grid(columns: (1fr, 1fr), gutter: 12pt, party("De", doc.from), party("Para", doc.to))

#v(10pt)
#doc.intro
#v(6pt)

#table(
  columns: (auto, 1fr, auto, auto, auto),
  align: (center, left, right, right, right),
  stroke: none,
  inset: (x: 7pt, y: 6pt),
  fill: (_, y) => if y == 0 { t.accent } else if calc.even(y) { t.subtle } else { none },
  table.header(..("#", "Descrição", "Qtd.", "Valor unit.", "Total").map(h => text(fill: white, weight: "bold", h))),
  ..doc.items.enumerate().map(((i, (d, q, p))) => (str(i + 1), d, str(q), m(p), m(q * p))).flatten(),
  table.hline(stroke: 0.6pt + t.line),
)

#align(right, block(width: 45%, {
  let rows(..cells) = grid(columns: (1fr, auto), align: (left, right), row-gutter: 6pt, ..cells)
  rows(
    [Subtotal], m(subtotal),
    ..if doc.discount > 0 { ([Desconto (#(doc.discount * 100)%)], [− #m(discount)]) },
    ..if doc.tax > 0 { ([Impostos (#(doc.tax * 100)%)], m(tax)) },
  )
  v(4pt)
  line(length: 100%, stroke: 0.8pt + t.ink)
  v(2pt)
  set text(weight: "bold", size: 12pt)
  rows([Total], text(fill: t.accent, m(total)))
}))

#v(12pt)
== Condições
#list(..doc.terms)
#if doc.kind == "proposal" [
  #text(fill: t.muted, size: 9pt)[Proposta válida por #doc.valid-days dias a partir de #doc.date.display("[day]/[month]/[year]").]
]

#v(1fr)
#align(center, block(width: 7cm, {
  line(length: 100%, stroke: 0.6pt + t.ink)
  v(-4pt)
  text(weight: "bold", doc.signer.name)
  linebreak()
  text(size: 9pt, fill: t.muted, doc.signer.role + " · " + doc.from.name)
}))
