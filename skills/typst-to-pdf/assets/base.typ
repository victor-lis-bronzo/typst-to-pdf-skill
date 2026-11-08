// base.typ: shared design tokens and helpers for typst-to-pdf documents.
// Copy next to the document and import with:  #import "base.typ": *
// Override tokens per document:              #let t = theme + (accent: rgb("#0f766e"))
//
// Font defaults use only fonts bundled with Typst, so every template compiles
// warning-free on any machine. The skill swaps in a system sans font found
// with `typst fonts` (see references/compile-verify.md).

#let theme = (
  accent: rgb("#1d4ed8"),   // brand / highlight color
  ink: rgb("#1f2937"),      // body text
  muted: rgb("#6b7280"),    // secondary text, captions
  paper: white,             // page background
  subtle: rgb("#f3f4f6"),   // fills: zebra rows, callouts, cards
  line: rgb("#d1d5db"),     // rules and borders
  font-body: ("Libertinus Serif",),
  font-head: ("Libertinus Serif",),
  font-mono: ("DejaVu Sans Mono",),
  size: 10.5pt,
  margin: 2.2cm,
)

// Lighten a color toward white; handy for tints of the accent.
#let tint(c, amount) = c.lighten(amount)

// Format a number as money: money(12480.5) -> "R$ 12.480,50".
#let money(x, symbol: "R$", dec: ",", sep: ".") = {
  let neg = x < 0
  let cents-total = int(calc.round(calc.abs(x) * 100))
  let whole = str(calc.quo(cents-total, 100))
  let cents = calc.rem(cents-total, 100)
  let digits = whole.clusters().rev()
  let out = ()
  for (i, d) in digits.enumerate() {
    if i > 0 and calc.rem(i, 3) == 0 { out.push(sep) }
    out.push(d)
  }
  let body = out.rev().join() + dec + (if cents < 10 { "0" } else { "" }) + str(cents)
  (if symbol != none and symbol != "" { symbol + " " } else { "" }) + (if neg { "-" } else { "" }) + body
}

// Thin horizontal rule.
#let divider(t: theme, space: 0.8em) = {
  v(space, weak: true)
  line(length: 100%, stroke: 0.6pt + t.line)
  v(space, weak: true)
}

// Small rounded label.
#let pill(body, t: theme, fill: none) = box(
  inset: (x: 6pt, y: 2.5pt),
  radius: 99pt,
  fill: if fill == none { tint(t.accent, 85%) } else { fill },
  text(size: 0.8em, fill: t.accent.darken(20%), weight: "medium", body),
)

// Highlighted note. kind: "info" | "success" | "warning" | "danger".
#let callout(body, title: none, kind: "info", t: theme) = {
  let c = (
    info: t.accent,
    success: rgb("#15803d"),
    warning: rgb("#b45309"),
    danger: rgb("#b91c1c"),
  ).at(kind)
  block(
    width: 100%,
    inset: (left: 12pt, rest: 10pt),
    radius: (right: 4pt),
    fill: tint(c, 92%),
    stroke: (left: 3pt + c),
    breakable: false,
    {
      if title != none { text(weight: "bold", fill: c.darken(15%), title); parbreak() }
      body
    },
  )
}

// Big number with a label underneath.
#let kpi(value, label, t: theme) = block(
  width: 100%,
  inset: 10pt,
  radius: 4pt,
  fill: t.subtle,
  {
    text(font: t.font-head, size: 1.9em, weight: "bold", fill: t.accent, value)
    linebreak()
    text(size: 0.85em, fill: t.muted, label)
  },
)

// Row of KPIs that share the width evenly: kpis(("42", "Clients"), ("98%", "Uptime"))
#let kpis(..items, t: theme) = grid(
  columns: (1fr,) * items.pos().len(),
  gutter: 10pt,
  ..items.pos().map(((v, l)) => kpi(v, l, t: t)),
)

// Table with a filled header row and zebra stripes.
// data-table(("Item", "Qty"), (("A", "1"), ("B", "2")), columns: (1fr, auto))
#let data-table(header, rows, columns: auto, align: auto, t: theme) = {
  let n = header.len()
  table(
    columns: if columns == auto { (1fr,) * n } else { columns },
    align: if align == auto { (x, y) => if x == 0 { left } else { right } } else { align },
    stroke: none,
    inset: (x: 7pt, y: 6pt),
    fill: (_, y) => if y == 0 { t.accent } else if calc.even(y) { t.subtle } else { none },
    table.header(..header.map(h => text(fill: white, weight: "bold", h))),
    ..rows.flatten().map(c => [#c]),
    table.hline(stroke: 0.6pt + t.line),
  )
}

// Apply page, text and heading defaults. Templates call this first:
//   #show: doc-defaults.with(t: t, lang: "pt")
#let doc-defaults(body, t: theme, lang: "pt", region: none, paper: "a4", flipped: false) = {
  set page(paper: paper, flipped: flipped, margin: t.margin, fill: t.paper)
  set text(font: t.font-body, size: t.size, fill: t.ink, lang: lang, region: region)
  set par(justify: true, leading: 0.65em)
  show heading: set text(font: t.font-head, fill: t.ink)
  show raw: set text(font: t.font-mono)
  show link: set text(fill: t.accent)
  body
}
