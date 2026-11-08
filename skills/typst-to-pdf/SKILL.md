---
name: typst-to-pdf
description: Builds polished PDFs with Typst from a request, notes, a file or the conversation, after a few optional questions. Use when the user wants a PDF, a report, résumé/CV, proposal, quote, invoice, letter, banner, poster or any custom printable document, or mentions Typst or asks to run typst-to-pdf.
---

# typst-to-pdf

Turn a request into a **finished PDF**: write one `.typ` source, compile it with the `typst` CLI, look at the result, and hand both files back. The `.typ` stays editable so the user can iterate.

Input (all optional, any order): free text describing the document, file paths with content or data (`.md`, `.txt`, `.csv`, `.json`, images), plus flags:

- `--template <report|resume|proposal|letter|banner|free>`: skip template choice.
- `--out <dir>`: output root (default `.typst-to-pdf/` in the current directory). Output always goes to `<out>/<slug>/`.
- `--lang <code>`: document language (default: the language the user writes in).
- `--paper <a4|us-letter|a5|WxH>`: page size (default `a4`; banners use their preset).
- `--no-ask`: skip the questions; go straight to defaults.

With no input, the content is the current conversation.

## Workflow

Run the steps in order. Keep the **doc brief** in your working notes; only the output folder is written to disk.

### 1. Intake

Read every source the user pointed at, then write the **doc brief**: kind, slug, title, audience, language, paper/orientation, content outline, data, visual identity (accent color, logo, fonts, tone), page target, assumptions.

Then ask **one round of optional questions**, at most 4, only about gaps that change the PDF (usually kind, audience/tone, visual identity, missing key data). Each question states its default, so the user can answer just "ok". Skip the round when the brief is already clear or `--no-ask` is set; every default you take becomes an **assumption**.

Done when: every brief field is filled or marked "default: …", and the user answered or the round was skipped.
Question bank, defaults, slug rule, brief format: [references/intake.md](references/intake.md).

### 2. Choose the template

| Request looks like | Template |
|---|---|
| report, relatório, study, manual, documentation, handout, ebook | `report.typ` |
| résumé, CV, currículo, portfolio one-pager | `resume.typ` |
| proposal, quote, orçamento, invoice, fatura, receipt, price list | `proposal.typ` |
| letter, carta, ofício, memo, declaration | `letter.typ` |
| banner, poster, social card, flyer, cover, event slide, single visual page | `banner.typ` |
| certificate, menu, badges, labels, program, invitation, anything else, a mix, or the user asks for something bespoke ("sob medida", "do zero", "free") | **free mode** |

Templates are starting points: rearrange, drop or add sections whenever the brief calls for it. In **free mode** design the layout from scratch on top of `generic.typ`; read [references/freeform.md](references/freeform.md) first.

Done when: one template (or free mode) is picked and the reason is in the brief.

### 3. Generate

Create `<out>/<slug>/` and copy into it, from this skill's `assets/`: `base.typ` and the chosen template renamed to `<slug>.typ` (free mode: copy only `base.typ` and write `<slug>.typ` fresh, keeping `generic.typ`'s DATA / LAYOUT / BODY split). Copy any images or data files the document uses into the same folder (Typst only reads files under the folder it compiles from).

Fill the **DATA** block, then the layout and body, following the brief. Write real content in the document's language: the user's own text first, then realistic, specific values in the user's domain. Pick fonts per [references/compile-verify.md](references/compile-verify.md#fonts) and set them in the theme.

Done when: no example data from the template remains, and every outline item in the brief appears in the source.
Typst syntax and the gotchas that break compiles: [references/typst-cheatsheet.md](references/typst-cheatsheet.md).

### 4. Compile and verify

From `<out>/<slug>/`: `typst compile <slug>.typ <slug>.pdf`, then render previews with `typst compile --ppi 80 <slug>.typ preview/page-{p}.png` and **view** them (every page when ≤ 6 pages, else the first two, the last and any page with a table or figure). Fix and recompile until the checklist passes, at most 3 rounds; report anything still open.

Done when: compile exits 0 with zero warnings, the PDF starts with `%PDF`, the page count fits the brief, and the viewed previews pass every item of the visual checklist.
Missing `typst`, fonts, packages, error fixes and the checklist: [references/compile-verify.md](references/compile-verify.md).

### 5. Hand off

Reply with: the PDF path, the `.typ` path, the template or free mode used, the page count, the assumptions, and an offer to open it (`xdg-open` on Linux, `open` on macOS, `start` on Windows). If `<out>` sits inside a git repo and is not ignored, suggest adding it to `.gitignore`.

Follow-ups ("make the title bigger", "add a section on X"): edit `<out>/<slug>/<slug>.typ` in place, keep the slug, re-run step 4. Intake is not repeated; ask again only if the change opens a new gap.
