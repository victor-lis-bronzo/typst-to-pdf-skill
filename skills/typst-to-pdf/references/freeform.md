# Free mode: bespoke documents

Use when no template fits, the request mixes kinds, or the user wants something made to measure. Start from `assets/generic.typ` (it keeps the DATA / LAYOUT / BODY split and imports `base.typ`), then **design** before you write code.

## 1. Design pass (in working notes)

Decide these five things, in order, and add them to the doc brief:

1. **Format**: page size and orientation from the use. Printed handout → A4/Letter; screen → 16:9 or social size; card → small custom size (`width: 85mm, height: 55mm`); several items per sheet (badges, labels, place cards) → A4 with a grid of cells.
2. **Grid**: the column structure. One column for reading; two for dense reference; sidebar + main for profiles; a cell grid for repeated items; full-bleed for visual pieces.
3. **Type scale**: 3–4 sizes, no more (e.g. body 10.5pt, h2 14pt, h1 22pt, display 40pt+). Head font can differ from body; keep one family when unsure.
4. **Color**: one accent plus neutrals from `theme`. Derive tints with `tint(accent, 85%)` and shades with `.darken(20%)`. A second accent only when it carries meaning (status, category).
5. **Components**: the 3–6 repeated pieces the document is made of (session card, menu item, checklist row, timeline entry…). Write each as a `#let` function in LAYOUT, then the BODY is just data run through them.

Done when: the five decisions are written down and every outline item maps to a component or plain text.

## 2. Build patterns

Data-driven repetition (menus, programs, catalogs, badges): keep items in an array of dictionaries in DATA and map them.

```typst
#let items = (
  (name: "Pão de fermentação natural", desc: "Farinha integral, 36h de fermentação", price: 24),
  (name: "Focaccia de alecrim", desc: "Azeite extravirgem e sal grosso", price: 32),
)
#let menu-item(it) = grid(
  columns: (1fr, auto),
  [*#it.name* \ #text(size: 0.85em, fill: t.muted, it.desc)],
  text(fill: t.accent, weight: "bold", money(it.price)),
)
#stack(spacing: 10pt, ..items.map(menu-item))
```

One page per record (certificates, personalized letters, invitations): write the page as a function and loop, breaking between records but not after the last.

```typst
#let certificate(p) = align(center + horizon)[
  #text(size: 28pt, weight: "bold", "CERTIFICADO") \
  #v(1cm) Certificamos que #v(4mm)
  #text(size: 24pt, style: "italic", p.name)
]
#for (i, p) in people.enumerate() {
  if i > 0 { pagebreak() }
  certificate(p)
}
```

Many cells per page (badges, labels, place cards, flashcards):

```typst
#set page(margin: 10mm)
#grid(columns: (1fr,) * 2, rows: 55mm, gutter: 6mm,
  ..people.map(p => rect(width: 100%, height: 100%, radius: 4pt, stroke: 0.6pt + t.line,
    align(center + horizon, [#text(size: 18pt, weight: "bold", p.name) \ #p.org]))))
```

Absolute composition (certificates, covers, posters): draw backgrounds with `place()` first, then content; size everything from one unit like `banner.typ` does (`#let u = calc.min(W, H) / 100`) so the layout survives size changes.

Timeline / schedule rows: a `grid(columns: (auto, 1fr))` per entry with time in the left column, or a `table` with `table.cell(colspan: …)` for breaks spanning rooms.

Multi-column reading text: `#set page(columns: 2)` for the whole document, or `#columns(2)[…]` for a region; `#colbreak()` forces the next column.

Charts without packages: simple bars are a `grid` of `rect(width: v / max * 100%, height: 8pt, fill: t.accent)`. For anything richer, ask before using a package (see compile-verify.md, Packages).

Booklet / zine feel: `#set page(width: 148mm, height: 210mm)` (A5), generous margins, `pagebreak(to: "odd")` before chapters.

## 3. Quality bar

Free mode is judged by the preview, not the source. Before hand-off, view the previews and check: clear hierarchy (the eye lands on the title first), consistent spacing (same gaps between same-level items), aligned edges, text never touching page edges or shapes, contrast readable, nothing overflowing its box.
