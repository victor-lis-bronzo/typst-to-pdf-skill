// banner.typ: single-page visual piece (banner, social card, poster, event
// slide). Custom page size, no margins, large type over a gradient with shapes.
// Pick a preset in `size`, or set (width, height) directly.
#import "base.typ": *

// ===== DATA ================================================================
#let presets = (
  social: (1200pt, 628pt),     // link preview / LinkedIn / Facebook post
  square: (1080pt, 1080pt),    // Instagram post
  story: (1080pt, 1920pt),     // vertical story
  slide: (1920pt, 1080pt),     // 16:9 screen
  header: (1500pt, 500pt),     // 3:1 profile / site header
  a4-landscape: (297mm, 210mm),
  a3-poster: (297mm, 420mm),
)
#let t = theme + (accent: rgb("#2563eb"))
#let b = (
  // A preset, (width, height), or override at compile time: --input preset=story
  size: presets.at(sys.inputs.at("preset", default: "social")),
  lang: "pt",
  kicker: "Lançamento · Novembro 2026",
  title: "Pedidos online em 10 minutos",
  subtitle: "Catálogo, carrinho e retirada na loja, integrados ao seu PDV.",
  cta: "waywize.com.br/pedidos",
  brand: "Waywize",
  logo: none,                  // e.g. "logo.png"
  from: rgb("#1e3a8a"),        // gradient start
  to: rgb("#7c3aed"),          // gradient end
  fg: white,
)

// ===== LAYOUT ==============================================================
#let (W, H) = b.size
#let u = calc.min(W, H) / 100 // 1% of the short side; scale everything by it

#set document(title: b.title, author: b.brand)
#set page(width: W, height: H, margin: 0pt, fill: gradient.linear(b.from, b.to, angle: 30deg))
#set text(font: t.font-head, fill: b.fg, lang: b.lang)
#set par(justify: false, leading: 0.5em)

// Decorative shapes (stay behind content because they come first)
#place(top + right, dx: 18 * u, dy: -22 * u, circle(radius: 48 * u, fill: white.transparentize(88%)))
#place(bottom + left, dx: -12 * u, dy: 14 * u, circle(radius: 30 * u, fill: white.transparentize(92%)))
#place(bottom + right, dx: -8 * u, dy: -8 * u, rect(width: 22 * u, height: 1.2 * u, fill: b.fg.transparentize(30%)))

#let pad = 8 * u
#place(top + left, dx: pad, dy: pad, block(width: W - 2 * pad, height: H - 2 * pad, {
  // Brand row
  if b.logo != none { image(b.logo, height: 6 * u) } else {
    text(size: 4.2 * u, weight: "bold", b.brand)
  }
  v(1fr)
  text(size: 3.4 * u, tracking: 0.15 * u, fill: b.fg.transparentize(20%), upper(b.kicker))
  v(2 * u)
  block(width: 85%, text(size: 10 * u, weight: "bold", b.title))
  v(3 * u)
  block(width: 70%, text(size: 4.2 * u, fill: b.fg.transparentize(10%), b.subtitle))
  v(1fr)
  if b.cta != none {
    box(inset: (x: 3 * u, y: 1.8 * u), radius: 99pt, fill: white,
      text(size: 3.6 * u, weight: "bold", fill: b.from, b.cta))
  }
}))
