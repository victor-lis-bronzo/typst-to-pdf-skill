# Compile and verify

## Typst CLI

Check with `typst --version`. If it is missing, stop and show the user the install command for their OS; install it yourself only after they agree.

| OS | Command |
|---|---|
| macOS | `brew install typst` |
| Windows | `winget install --id Typst.Typst` |
| Arch | `pacman -S typst` |
| Any (Rust) | `cargo install --locked typst-cli` |
| Any (binary) | download from https://github.com/typst/typst/releases and put `typst` on `PATH` |

Without Typst the `.typ` is still useful: write it, say it was not compiled, and point to https://typst.app (paste the files there to get the PDF).

## Fonts

Every family named in a font list that is not installed produces an `unknown font family` warning, even when a later one in the list exists. So the theme lists **only installed fonts**.

`base.typ` defaults to fonts bundled inside Typst (`Libertinus Serif`, `DejaVu Sans Mono`), which always exist. Most documents look more modern with a sans head font (and often sans body). Find what is installed:

```bash
typst fonts | grep -ixE 'Inter|IBM Plex Sans|Source Sans 3|Roboto|Open Sans|Lato|Noto Sans|Helvetica Neue|Helvetica|Arial|Segoe UI|Liberation Sans|DejaVu Sans'
```

Pick the first hit in that preference order and always set it as `font-head`: `#let t = theme + (font-head: ("Noto Sans",))`. For `font-body`, choose by how the text is read: **paragraphs read top to bottom** (reports, letters, long documents) keep the serif `Libertinus Serif`; **pieces scanned at a glance** (banners, résumés, proposals, badges, menus) use the sans for body too. Certificates and invitations may pair a serif for the name or title with the sans elsewhere. Nothing found → keep the defaults.

User-supplied font files (`.ttf`/`.otf`): copy them to `<out>/<slug>/fonts/`, compile with `--font-path fonts`, and check the exact family name with `typst fonts --font-path fonts`.

Glyphs missing from the chosen font (emoji, CJK, arrows) fall back automatically; if a box with a cross shows up in the preview, add a font that covers them (`Noto Color Emoji`, `Noto Sans CJK SC`, …) at the end of the list.

## Packages

`#import "@preview/<name>:<version>"` downloads from the internet on first compile and caches it. Prefer plain Typst (everything in `assets/` is package-free). Use a package only when it saves real work the user wants (QR codes, complex charts, Gantt diagrams); say so in the hand-off. If the download fails (offline, sandbox), rewrite without it.

## Commands

Run from `<out>/<slug>/`:

```bash
typst compile <slug>.typ <slug>.pdf                     # the PDF
rm -rf preview && mkdir preview
typst compile --ppi 80 <slug>.typ "preview/page-{p}.png" # one PNG per page
head -c 4 <slug>.pdf                                     # must print %PDF
ls preview | wc -l                                       # page count
```

Add `--font-path fonts` when the folder has fonts, `--input key=value` for template inputs (e.g. `--input preset=story` in `banner.typ`). Use `typst watch` only if the user asks for live preview.

## Checklist

Compile:

- [ ] Exit code 0 and **zero** warnings (warnings usually mean a missing font, an empty `**`, or a broken reference).
- [ ] PDF starts with `%PDF`; page count fits the brief's page target.

Visual (view the PNGs):

- [ ] No leftover template example data, `TODO`, or placeholder text.
- [ ] No text overflowing a box, page edge or colored shape; no clipped table columns.
- [ ] No orphan heading at a page bottom and no near-empty last page (tighten spacing or content instead).
- [ ] Money, `@` and `//` render literally (no math-italic `R`, no missing line tails; see the cheatsheet escapes).
- [ ] Accents and special characters render (no tofu boxes); dates and numbers in the document's locale.
- [ ] Images visible and not stretched; logo legible.
- [ ] Hierarchy reads at a glance: title → headings → body; consistent spacing.

## Common errors

| Message | Cause → fix |
|---|---|
| `unknown font family: x` (warning) | font not installed → pick from `typst fonts` |
| `label <x> does not exist` | `@` in text (often an email) → `\@` or a `link("mailto:…")` |
| `unclosed delimiter` | stray `*`, `_` or `[` in markup → escape it |
| `file not found` / `access denied` | path outside the project root or wrong relative path → copy the file into `<out>/<slug>/` |
| `unexpected argument: leading` (or `justify`, `spacing`, `first-line-indent`) | paragraph settings belong to `par`, not `text` → `#set par(leading: 0.6em)` |
| `expected string, found integer` (or similar) | convert with `str(x)` before concatenating with `+` |
| `cannot access fields on type …` | dictionary key missing → check DATA, or `.at("k", default: …)` |
| `only element functions can be used as selectors` | old `locate(...)` API → `context` |
| `unknown variable: x` | `#let` defined after use, or inside a block (scoped) → move it up |
| Layout `layout did not converge` (warning) | a `context` value changes the layout it measures → simplify the header/footer logic |
