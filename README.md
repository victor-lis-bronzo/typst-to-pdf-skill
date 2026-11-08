# typst-to-pdf

> Ask for a document, get a PDF.

`typst-to-pdf` is an agent skill for **Claude Code** and **Google Antigravity (`agy`)**. Describe the document you need (or point at notes, a Markdown file, a CSV), answer a few optional questions, and the agent writes a [Typst](https://typst.app) source, compiles it, checks the rendered pages and hands you the PDF.

```
/typst-to-pdf a one-page résumé from my notes in cv.md
/typst-to-pdf proposal for Padaria Pão Dourado, 3 items, 5% discount
/typst-to-pdf quarterly report from sales.csv --lang en
/typst-to-pdf a 1200x628 launch banner, purple, with logo.png
/typst-to-pdf a conference badge sheet, 8 per A4 page --no-ask
/typst-to-pdf                       # uses the current conversation as the content
```

## What you get

Written to `<out>/<slug>/` (default `<out>` = `.typst-to-pdf/`):

```
.typst-to-pdf/proposta-padaria-pao-dourado/
├── proposta-padaria-pao-dourado.pdf   the document
├── proposta-padaria-pao-dourado.typ   editable source: DATA block on top, layout below
├── base.typ                           shared tokens and helpers (money, tables, callouts, KPIs)
├── preview/page-1.png …               the renders the agent checked
└── logo.png, data.csv, fonts/ …       anything the document uses, copied in
```

- **Asks little, assumes visibly.** One optional round of at most 4 questions, each with a default; reply "ok" or pass `--no-ask`. Every default is listed as an assumption in the hand-off.
- **Templates when they fit, bespoke when they don't.** Report, résumé, proposal/invoice, letter and banner templates ship with the skill; anything else (certificates, menus, badges, programs, zines…) is designed from scratch in *free mode*.
- **Checked, not just compiled.** Zero-warning compile, then the agent looks at the page renders for overflow, missing glyphs, broken money signs and empty pages before handing off.
- **Yours to edit.** The `.typ` keeps content in a DATA block at the top; ask for changes in conversation and the agent edits and recompiles in place.

## Templates

| Template | For | Includes |
|---|---|---|
| `report` | reports, studies, manuals, handouts | cover, table of contents, numbered sections, KPIs, tables, header/footer |
| `resume` | CV / résumé, 1–2 pages | sidebar with contact, skills, languages; experience and education |
| `proposal` | proposals, quotes, invoices | parties, line items with computed totals, discount/tax, terms, signature |
| `letter` | letters, ofícios, memos, declarations | letterhead, recipient, date, subject, body, signature |
| `banner` | social cards, posters, story, slides | presets: `social`, `square`, `story`, `slide`, `header`, `a4-landscape`, `a3-poster` |
| free mode | anything else | layout designed for the request on top of `generic.typ` |

## Requirements

[Typst CLI](https://github.com/typst/typst#installation) 0.12 or newer on `PATH`:

```bash
brew install typst                    # macOS
winget install --id Typst.Typst       # Windows
cargo install --locked typst-cli      # anywhere with Rust
```

No Typst? The skill still writes the `.typ` and tells you how to compile it (or paste it into typst.app).

## Install

Pick one.

### 1. `npx skills` (Claude Code + Antigravity in one go)

```bash
npx skills add victor-lis-bronzo/typst-to-pdf-skill --skill typst-to-pdf -g -a claude-code -a antigravity-cli -y
```

Drop `-g` to install into the current project instead. Add `-a antigravity` for the Antigravity IDE, or `--copy` to copy files rather than symlink.

### 2. Claude Code plugin

```bash
claude plugin marketplace add victor-lis-bronzo/typst-to-pdf-skill
claude plugin install typst-to-pdf@typst-to-pdf-skill
```

Plugin skills are namespaced: invoke as `/typst-to-pdf:typst-to-pdf`.

### 3. Antigravity plugin

```bash
git clone https://github.com/victor-lis-bronzo/typst-to-pdf-skill
agy plugin install ./typst-to-pdf-skill
```

After `agy plugin install`, ask for it by name or type `/typst-to-pdf` in the `agy` TUI; run `agy plugin list` to see the exact name.

### 4. Install script

```powershell
# Windows (PowerShell)
git clone https://github.com/victor-lis-bronzo/typst-to-pdf-skill; cd typst-to-pdf-skill
./scripts/install.ps1                    # global, Claude + Antigravity
./scripts/install.ps1 -Claude            # Claude only
./scripts/install.ps1 -Agy               # Antigravity only
./scripts/install.ps1 -Project C:\path\to\repo
./scripts/install.ps1 -Link              # symlink: `git pull` updates the skill
./scripts/install.ps1 -Uninstall
```

```bash
# macOS / Linux / Git Bash
./scripts/install.sh                     # global, Claude + Antigravity
./scripts/install.sh --agy
./scripts/install.sh --project ~/code/my-app
./scripts/install.sh --link
./scripts/install.sh --uninstall
```

### Manual

Copy `skills/typst-to-pdf/` to:

| Where | Claude Code | Antigravity |
|---|---|---|
| Global | `~/.claude/skills/typst-to-pdf` | `~/.gemini/config/skills/typst-to-pdf` |
| Project | `.claude/skills/typst-to-pdf` | `.agents/skills/typst-to-pdf` |

Manual, script and `npx skills` installs invoke as plain `/typst-to-pdf`. The skill also triggers on its own when you ask for a PDF, résumé, proposal, banner and so on.

## Usage

| Input | Example |
|---|---|
| Free text | `/typst-to-pdf a recipe card for pão de queijo, A5` |
| Content file | `/typst-to-pdf notes/meeting.md as a formal memo` |
| Data file | `/typst-to-pdf invoice from items.csv` |
| Images | `/typst-to-pdf poster for the event, use photo.jpg and logo.svg` |
| Nothing | `/typst-to-pdf` after discussing the document |

| Flag | Effect |
|---|---|
| `--template <report\|resume\|proposal\|letter\|banner\|free>` | Skip template choice |
| `--out <dir>` | Output root (default `.typst-to-pdf/`) |
| `--lang <code>` | Document language (default: the language you write in) |
| `--paper <a4\|us-letter\|a5\|WxH>` | Page size (default `a4`; banners use a preset) |
| `--no-ask` | Skip the questions, use defaults |

Iterate in conversation ("make the header green", "add a page with the timeline"): the skill edits the same `.typ` and recompiles.

## How it works

1. **Intake**: read the sources, write a doc brief, ask at most 4 optional questions.
2. **Choose**: a template, or free mode for bespoke layouts.
3. **Generate**: copy `base.typ` + template into the output folder, fill the DATA block and body.
4. **Compile and verify**: zero-warning compile, render PNG previews, look at them, fix (up to 3 rounds).
5. **Hand off**: PDF and source paths, assumptions, offer to open.

The workflow lives in [`skills/typst-to-pdf/SKILL.md`](skills/typst-to-pdf/SKILL.md); details are in `references/`, templates in `assets/`.

## Developing

Every template compiles standalone with sample data:

```bash
cd skills/typst-to-pdf/assets
for f in report resume proposal letter banner generic; do typst compile $f.typ /tmp/$f.pdf; done
typst compile --input preset=story banner.typ /tmp/story.pdf
```

## Releasing

The version lives in both `plugin.json` (repo root, for agy) and `.claude-plugin/plugin.json` (Claude). Bump both.

## License

MIT
