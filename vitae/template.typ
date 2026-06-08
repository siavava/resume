#let maroon = rgb("#7c1f2b")
#let linkblue = rgb("#26408b")
#let body-font = "TeX Gyre Pagella"
#let mono-font = "Latin Modern Mono"

#let mono(body) = text(font: mono-font, size: 0.95em)[#body]

// An ⟨email / url⟩ rendered in blue typewriter inside angle brackets.
#let weblink(target, shown) = {
  link(target)[#text(fill: linkblue)[⟨#mono(shown)⟩]]
}

// An inline prose hyperlink — the linked words tinted the same blue as the
// ⟨url⟩ links, so every clickable element shares one treatment.
#let tlink(target, body) = link(target, text(fill: linkblue)[#body])

// Roman-numeral + title section heading, centred in maroon small caps.
#let section(numeral, title) = {
  v(4.8em, weak: true)
  // Keep the numeral and title together, and never orphan them at a page foot.
  block(breakable: false, width: 100%)[
    #align(center)[
      #text(fill: maroon, size: 1.25em, tracking: 0.12em)[#numeral]
      #v(0.35em, weak: true)
      #text(fill: maroon, size: 1.02em, tracking: 0.18em)[#smallcaps(title)]
    ]
  ]
  v(1.6em, weak: true)
}

// Bold, centred black sub-heading.
#let subsection(title) = {
  v(1.9em, weak: true)
  align(center, text(weight: "bold")[#title])
  v(1.0em, weak: true)
}

// A top-level CV entry (job, role) with a hanging number and clear
// separation from its neighbours. Nested lists inside stay tight, so each
// entry reads as one distinct block.
#let entry(number, body) = {
  v(1.8em, weak: true)
  block(width: 100%, breakable: true, {
    set enum(spacing: 0.85em)
    set list(spacing: 0.7em)
    set par(spacing: 0.95em)
    grid(
      columns: (1.6em, 1fr),
      column-gutter: 0pt,
      align: (left + top, left + top),
      text[#number.], body,
    )
  })
}

// Two-column label / value rows used in the personal-data block.
// An empty label (`[]`) yields a blank cell — used for continuation lines.
#let datablock(..rows) = {
  let pairs = rows.pos()
  grid(
    columns: (auto, 1fr),
    row-gutter: 0.95em,
    column-gutter: 1.1em,
    ..pairs.map(p => {
      let label = p.at(0)
      let cell = if label == [] or label == "" { [] } else {
        text(weight: "bold", style: "italic")[#label:]
      }
      (cell, p.at(1))
    }).flatten()
  )
}

#let cv(body) = {
  set page(
    paper: "a4",
    margin: (x: 3.1cm, top: 2.6cm, bottom: 2.4cm),
    numbering: "1",
    number-align: center,
    header: context {
      // Header rule on every page except the first.
      if counter(page).get().first() > 1 {
        line(length: 100%, stroke: 0.5pt + black)
      }
    },
  )

  // Body is TeX Gyre Pagella — the same Palatino lineage the reference uses,
  // with genuine small caps and old-style figures. The font is vendored under
  // ./fonts AND installed to ~/Library/Fonts so every build path (CLI, the
  // Makefile, and the editor's Typst LSP) resolves it and embeds it in the PDF.
  set text(
    font: body-font,
    size: 10.5pt,
    number-type: "old-style",
    lang: "en",
  )

  // Inline code (e.g. `IROC`) uses the same typewriter face as the links.
  show raw: set text(font: mono-font)

  set par(justify: true, leading: 0.82em, spacing: 1.35em)

  // Numbered / nested lists styled like the LaTeX original.
  set enum(numbering: "1.", indent: 0.4em, body-indent: 0.5em, spacing: 1.2em)
  set list(marker: ([•], [–], [·]), indent: 0.4em, body-indent: 0.5em, spacing: 1.05em)

  // Title plate: small-caps maroon, ruled above and below.
  align(center)[
    #block(
      stroke: (top: 0.6pt + black, bottom: 0.6pt + black),
      inset: (y: 7pt, x: 10pt),
    )[
      #text(fill: maroon, size: 1.7em, tracking: 0.12em)[#smallcaps[Curriculum Vitæ]]
    ]
  ]
  v(2.2em)

  body
}
