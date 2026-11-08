// letter.typ: formal letter / ofício / memo. Sender letterhead, recipient
// block, place and date, subject, body, closing and signature.
#import "base.typ": *

// ===== DATA ================================================================
#let t = theme + (accent: rgb("#334155"), size: 11pt, margin: 2.5cm)
#let letter = (
  lang: "pt",
  reference: "Ofício nº 042/2026", // none to hide
  place: "São Paulo",
  date: datetime(year: 2026, month: 11, day: 8),
  from: (
    name: "Associação de Moradores do Jardim Aurora",
    lines: ("Rua das Acácias, 120 — Jardim Aurora", "São Paulo, SP · 04567-000", "contato@jardimaurora.org.br"),
  ),
  to: (
    salutation: "Ilmo. Sr.",
    name: "Carlos Mendes",
    role: "Subprefeito da Vila Mariana",
    lines: ("Rua José de Magalhães, 500", "São Paulo, SP · 04026-090"),
  ),
  subject: "Solicitação de manutenção da iluminação pública",
  opening: "Prezado Senhor,",
  body: [
    Vimos, por meio deste, solicitar a manutenção da iluminação pública na
    Rua das Acácias, entre os números 80 e 240, onde seis postes estão sem
    funcionamento desde setembro, conforme protocolos 2026-118734 e 2026-121090.

    A ausência de iluminação tem gerado insegurança aos moradores,
    especialmente estudantes que retornam da escola no período noturno.

    Colocamo-nos à disposição para acompanhar a vistoria técnica e fornecer
    informações adicionais.
  ],
  closing: "Atenciosamente,",
  signer: (name: "Helena Prado", role: "Presidente"),
)

// ===== LAYOUT ==============================================================
#let months-pt = ("janeiro", "fevereiro", "março", "abril", "maio", "junho",
  "julho", "agosto", "setembro", "outubro", "novembro", "dezembro")
#let long-date(d) = if letter.lang == "pt" {
  str(d.day()) + " de " + months-pt.at(d.month() - 1) + " de " + str(d.year())
} else { d.display("[month repr:long] [day], [year]") }

#set document(title: letter.subject, author: letter.from.name)
#show: doc-defaults.with(t: t, lang: letter.lang)
#set par(first-line-indent: 0pt, spacing: 1.1em)

// Letterhead
#text(font: t.font-head, size: 14pt, weight: "bold", fill: t.accent, letter.from.name)
#linebreak()
#text(size: 8.5pt, fill: t.muted, letter.from.lines.join("  ·  "))
#v(-2pt)
#line(length: 100%, stroke: 1pt + t.accent)
#v(14pt)

#grid(
  columns: (1fr, auto),
  if letter.reference != none { text(weight: "bold", letter.reference) },
  [#letter.place, #long-date(letter.date).],
)
#v(14pt)

#letter.to.salutation \
*#letter.to.name* \
#letter.to.role \
#for l in letter.to.lines [#l \ ]

#v(10pt)
*Assunto:* #letter.subject
#v(10pt)

#letter.opening

#letter.body

#letter.closing

#v(2.2cm)
#block(width: 7cm, {
  line(length: 100%, stroke: 0.6pt + t.ink)
  v(-4pt)
  text(weight: "bold", letter.signer.name)
  linebreak()
  text(size: 9.5pt, fill: t.muted, letter.signer.role)
})
