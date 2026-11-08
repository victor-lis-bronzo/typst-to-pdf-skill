# Typst cheatsheet (0.13+)

Typst is not Markdown and not LaTeX. This page caches what breaks compiles or silently corrupts output; for anything else, the official docs are at https://typst.app/docs. Check the installed version with `typst --version`; features below need 0.12+, tested on 0.13.

## Markup vs Markdown

| Want | Typst markup | Markdown habit that breaks |
|---|---|---|
| Heading | `= Title`, `== Sub` | `# Title` (that is code mode) |
| Bold / italic | `*bold*`, `_italic_` | `**bold**` (empty-bold warnings, text not bold) |
| Link | `#link("https://x.com")[label]` | `[label](url)` |
| Bullet / numbered | `- item`, `+ item` | `1. item` works too |
| Term list | `/ Term: description` | — |
| Line break | `\` at end of line | two trailing spaces |
| Code | `` `inline` ``, ```` ```lang ```` blocks | same |
| Image | `#image("logo.png", width: 3cm)` | `![alt](src)` |
| Footnote | `#footnote[text]` | `[^1]` |
| Quote | `#quote(block: true)[text]` | `> text` |

When converting the user's Markdown, rewrite it into Typst markup; do not paste it raw.

## Characters that must be escaped in markup

These are the top cause of broken documents. In **markup** (body text), escape with `\`; inside **strings** (`"..."` in code) they are plain characters, which is one reason the templates keep data in strings.

| Char | Problem in markup | Write |
|---|---|---|
| `$` | starts math; `R$ 100 e R$ 200` compiles **silently** as a formula | `R\$ 100`, or `#money(100)` |
| `@` | `ana@empresa.com` becomes a reference → error | `ana\@empresa.com`, or `#link("mailto:ana@empresa.com")` |
| `//` | starts a comment, silently drops the rest of the line (URLs with `https://` are fine) | `\/\/` |
| `*`, `_` | stray one opens bold/italic → "unclosed delimiter" | `\*`, `\_` (`snake_case` mid-word is fine) |
| `#` | starts code | `\#` |
| `<`, `>` | `<word>` becomes a label | `\<word\>` |
| `` ` `` | starts raw | `` \` `` |

## Code mode essentials

- `#` enters code from markup: `#let x = 5`, `#x`, `#upper("a")`. Inside `{ }` or function args you are already in code; use `[ ... ]` to go back to markup.
- Content arguments: `#block(fill: red)[text]` equals `#block(fill: red, [text])`.
- Dictionaries: `(name: "A", n: 1)`; access `d.name`, safe access `d.at("k", default: none)`; merge `a + b` (right wins). Arrays: `(1, 2)`; a one-element array needs a trailing comma: `("x",)`.
- Destructuring: `let (w, h) = size`; in closures `((a, b)) => a + b`.
- Spread: `..array` into arguments; `items.map(f).join()` builds content.
- `str(3)`, `int("3")`, `float(x)`, `calc.round(x, digits: 2)`, `calc.rem`, `calc.quo`, `calc.min/max`.
- Field access ends at whitespace or punctuation: `#meta.title.` prints the title then a period.

## Styling

- `#set text(font: ("Inter",), size: 11pt, lang: "pt", fill: rgb("#222"))`, `#set par(justify: true, leading: 0.65em)`.
- `#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm), flipped: true, header: …, footer: …, numbering: "1")`. Custom size: `width: 1200pt, height: 628pt`.
- `#show heading.where(level: 1): set text(fill: blue)`; full rewrite: `#show heading: it => block(…, it.body)`.
- `#show: template.with(arg: …)` applies a function to everything after it; put it before the body.
- `set` rules are scoped to the enclosing block `{ }` / `[ ]`; put them at top level to affect the whole document.
- Units: `pt mm cm in em %` and `fr` (fraction of remaining space in grids/stacks/`v`/`h`).
- Colors: `rgb("#1d4ed8")`, `luma(90%)`, `.lighten(80%)`, `.darken(20%)`, `.transparentize(50%)`, `gradient.linear(a, b, angle: 30deg)`.

## Layout

- `grid(columns: (1fr, 2fr), gutter: 10pt, a, b)`: layout without lines. `table(...)` for data, with `table.header(..)` repeating across pages, `table.cell(colspan: 2)[x]`, `table.hline()`.
- `stack(dir: ttb, spacing: 6pt, ..)`, `align(center + horizon)[..]`, `box` (inline) vs `block` (breaks lines), `place(top + right, dx: 1cm)[..]` (absolute, no layout space), `pad(x: 1cm)[..]`.
- `v(1fr)` pushes following content to the page bottom; `pagebreak()`, `colbreak()`.
- `block(breakable: false)` keeps a card/table on one page.
- `image("x.png", width: 100%, fit: "cover")`; PNG, JPEG, GIF and SVG work everywhere; convert other formats first.

## Context-dependent values

Page numbers, counters, `here()`, `measure()` and `query()` need `context`:

```typst
#set page(footer: context align(right, counter(page).display("1 / 1", both: true)))
```

`locate(loc => …)` is the old API and fails ("only element functions can be used as selectors"); use `context` instead.

## Data, files and dates

- `csv("data.csv")` returns rows of strings (first row = header); `json("x.json")`, `yaml("x.yaml")`, `read("x.txt")`.
- File paths are relative to the `.typ` file and must stay inside the project root (default: the folder of the compiled file). Copy files into `<out>/<slug>/` rather than pointing outside it, or pass `--root`.
- `datetime(year: 2026, month: 11, day: 8)`, `datetime.today()`; `d.display("[day]/[month]/[year]")`. Month names follow `[month repr:long]` in English only; for other languages map numbers to names yourself (see `letter.typ`).
- Values from the command line: `typst compile --input key=value f.typ` → `sys.inputs.at("key", default: "…")`.

## Document structure

- `#set document(title: "…", author: "…")` fills PDF metadata; set it in every document.
- `#outline()` table of contents; `#set heading(numbering: "1.1")`.
- `#figure(image("c.png"), caption: [..]) <fig-x>` then `@fig-x` to reference it.
- Bibliography: `#bibliography("refs.bib", style: "apa")` (BibTeX or Hayagriva YAML in the folder).
- Math: `$x^2$` inline, `$ x^2 $` (with spaces) as a block.
