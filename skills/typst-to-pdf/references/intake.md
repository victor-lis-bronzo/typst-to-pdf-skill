# Intake

Goal: one **doc brief** that drives every later step, plus one optional round of questions. Speed matters: a good default beats a long interview.

## 1. Gather sources

| Input | How to read it |
|---|---|
| Free text in the request | It is the brief seed: kind, purpose, content. |
| Local file (`.md`, `.txt`, `.docx` text, notes) | Read it. Its text is the document content; keep the user's wording. |
| Data file (`.csv`, `.json`, `.yaml`) | Read it to understand columns. Plan to copy it next to the `.typ` and load it with `csv()` / `json()` / `yaml()` instead of retyping numbers. |
| Image (logo, photo, chart) | Copy next to the `.typ`; view it if you can, to pick colors that match a logo. |
| URL | Fetch with your web tool if available; otherwise ask the user to paste it. |
| Nothing | Use the current conversation: what was discussed, decided, written. |

Ask for content only when there is none anywhere (empty request and nothing in the conversation). Ask once, for the content itself.

## 2. Doc brief

Keep it in working notes, bullets only, these fields in this order:

```markdown
## Doc brief
- **Kind:** report | resume | proposal | invoice | letter | banner | free: <what exactly>
- **Slug:** <kebab-case, ≤ 5 words>
- **Title:** <as printed>
- **Audience & purpose:** <who reads it, what they should do or feel after>
- **Language:** <pt-BR, en-US, …>  (number/date formats follow it)
- **Paper:** <a4 portrait | us-letter | 1200x628 | …>
- **Outline:** <sections in order, each with 1-line content note>
- **Data:** <tables, figures, amounts; source file if any>
- **Visual identity:** accent <#hex>, logo <path|none>, fonts <body/head>, tone <sober | modern | playful | academic>
- **Page target:** <e.g. 1 page, 2–4 pages>
- **Template:** <name or free mode: reason>
- **Assumptions:** <every default you took, one checkable sentence each>
```

Slug: lowercase ASCII, hyphens, no stopwords, ≤ 5 words: "Proposta para Padaria Pão Dourado" → `proposta-padaria-pao-dourado`. If `<out>/<slug>/` already exists and this is a new document, append `-2`.

## 3. Optional questions

One round, at most 4 questions, picked from the bank below in this priority order, **only for fields the sources leave open and that change the PDF**. Every question carries its default and is skippable.

How to ask: use your structured question tool when the environment has one (for example `AskUserQuestion` in Claude Code), with the default as the first option marked "(Recommended)". Otherwise send one short message with numbered questions, each ending in "(default: …)", and say that replying "ok" accepts all defaults.

| Field | Ask when | Example question | Default |
|---|---|---|---|
| Kind | the request fits two templates or none | "Is this a one-page proposal or a full report?" | closest template from SKILL.md step 2 |
| Audience & tone | it changes length or formality | "Who will read this: client, internal team or public?" | sober, professional |
| Visual identity | no colors/logo given and the piece is outward-facing | "Any brand color or logo file to use?" | template accent color, no logo |
| Key data | a required value is missing (prices, dates, names, contact) | "What are the unit prices for X and Y?" | realistic placeholder marked in the assumptions |
| Paper / size | banner without size, or user is likely outside A4 regions | "Which size: social 1200×628, square, story, A4 or A3 poster?" | `a4`; banners `social` |
| Length | report-like with no target | "Roughly how many pages?" | as short as the content allows |

Never ask about things you can decide well yourself (fonts, margins, section order, table style). With `--no-ask`, skip this section entirely.

## 4. Defaults and ambiguity

- Language: the language the user writes in; dates and money in that locale (`08/11/2026`, `R$ 1.234,56` for pt-BR; `Nov 8, 2026`, `$1,234.56` for en-US).
- Paper: `a4` portrait, unless the user's locale is US/Canada (`us-letter`) or the kind is a banner.
- Missing **figures** (prices, quantities, dates, IDs): fill a realistic value, list it under Assumptions, and point it out in the hand-off so the user replaces it.
- Missing **people** (signers, contacts, authors the user did not name): print the role only ("Coordenação", "Responsável técnico") with a blank signature line, and keep a `name: none` field in DATA for the user to fill. Facts about real people or companies come only from the user.
- Two plausible readings: build the primary one, mention the alternative in the hand-off.
