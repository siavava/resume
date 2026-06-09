// Résumé — a two-column layout built on the `lavandula` template, themed to
// match the CV's maroon. Reads the SAME shared data source (/data.yaml).
//
// Requires: Font Awesome 7 Desktop fonts + Fira Sans (vendored under ./fonts,
// also installed system-wide). Build with `make` (sets --root to the repo).

#import "@preview/lavandula:0.1.1": *

#let data = yaml("/data.yaml")

#show: lavandula-theme.with(custom-colors: (
  primary: rgb("#2f57d6"),
  secondary: rgb("#f1f3fb"),
))

// Fira Sans is lavandula's (and the sample template's) face.
#set text(lang: "en", font: ("Fira Sans", "Helvetica Neue"))
#set document(title: data.personal.name, author: data.personal.name, date: none)

// A couple of glyphs in the shared data (the math tilde and the U+2212 minus)
// aren't in Fira Sans and would otherwise fall back to a serif — normalise them
// to their ASCII equivalents so the whole résumé stays sans-serif.
#show "∼": "~"
#show "−": "-"

#let accent = rgb("#2f57d6")

// Inline-markup evaluator: the shared data uses #tlink("url")[text]; here we
// render those as themed (highlighted) links so they fit lavandula's palette.
#let md(body) = eval(body.trim(), mode: "markup", scope: (
  tlink: (url, b) => link(url, highlight(b)),
  weblink: (url, disp) => link(url, disp),
  mono: (b) => raw(b),
))

// A list with en-dash markers in the accent colour, used for all bullet lists.
#let dash-list(items) = {
  set list(marker: text(fill: accent)[–], indent: 0pt, body-indent: 0.5em, spacing: 0.42em)
  list(..items)
}

// Tighter inter-section gap than lavandula's default (3.5em) to keep one page.
#let section(title: "", body) = block(width: 100%, below: 1.5em)[
  == #title
  #block(inset: (x: 0.5pt), width: 100%, body)
]

#let strip-scheme(s) = s.replace("https://", "").replace("http://", "")

// Map a contact label to its (icon, solid?) pair.
#let contact-style = (
  "E-mail": ("at", true),
  "Website": ("globe", true),
  "GitHub": ("github", false),
  "LinkedIn": ("linkedin", false),
)

#let build-contacts(p) = {
  let items = p.contacts.map(c => {
    let (icon, solid) = contact-style.at(c.label, default: ("link", true))
    (icon: icon, icon-solid: solid, text: link(c.url)[#strip-scheme(c.display)])
  })
  items + ((icon: "phone", icon-solid: true, text: p.phone),)
}

// A shared entry layout (used for jobs and schooling): bold title with dates
// flush-right, an optional location line beneath, a blank line, then the body.
#let entry(title, dates, body, location: none) = block(width: 100%, below: 1.05em, {
  grid(
    columns: (1fr, auto),
    align: (bottom + left, bottom + right),
    column-gutter: 9pt,
    text(weight: "semibold", title),
    text(size: sizes.text-s3, emph(dates)),
  )
  if location != none {
    v(0.2em)
    text(size: sizes.text-s2, fill: accent)[#location]
  }
  v(0.6em)
  body
})

#let render-job(e) = entry(
  e.role + " @ " + e.org, e.period, location: e.at("location-short"),
  {
    set par(justify: true, spacing: 1em)
    md(e.summary)
    v(0.45em)
    set text(size: sizes.text-s2)
    dash-list(e.responsibilities.map(md))
  },
)

// ── Sidebar ────────────────────────────────────────────────────────────────
#let sidebar = [
  = #data.personal.name
  ==== #data.personal.headline

  #contact-list(build-contacts(data.personal))

  #sidebar-section(title: "About me")[
    #set par(justify: true)
    #md(data.personal.summary)
  ]

  #sidebar-section(title: "Technical skills")[
    #for g in data.skills.groups {
      skill-group(
        name: g.name,
        icon: g.icon,
        icon-solid: g.at("icon-solid", default: false),
        skills: g.skills,
      )
    }
  ]
]

// ── Main content ───────────────────────────────────────────────────────────
#let edu = data.education
#let project = edu.coursework.find(c => "url" in c)
#let yc = edu.at("other-programs").at(0)
#let ta = data.teaching.at(0)

#let main = [
  #section(title: "Experience")[
    #for e in data.experience { render-job(e) }
  ]

  #section(title: "Education")[
    #entry(edu.institution.name, edu.period, location: edu.at("location-short"), {
      set par(justify: true, spacing: 1em)
      [#emph(edu.degree)]
      v(0.45em)
      set text(size: sizes.text-s2)
      dash-list((
        [Honors: #edu.honors.join(", ").],
        [Relevant coursework: #md(edu.at("relevant-coursework")).],
        [#link(ta.org)[Teaching Assistant] for #ta.courses.len() CS courses: #ta.courses.map(c => link(c.url, c.name)).join(", ").],
      ))
    })

    #entry(yc.program.name, "2022", {
      emph(yc.description)
    })
  ]

  #section(title: "Highlights")[
    #section-element(title: "Capstone project", info: emph[Senior Design Challenge])[
      #v(0.5em)
      #set text(size: sizes.text-s2)
      #link(project.url, highlight[Discite]) — #md(project.body)
    ]

    #section-element(title: "Publications", info: emph[Dartmouth Undergraduate Journal of Science])[
      #v(0.5em)
      #set text(size: sizes.text-s2)
      #dash-list(data.publications.items.map(p => [#link(p.url, highlight(p.title)) — #emph(p.date).]))
    ]

    #section-element(title: "Projects", info: emph[GitHub])[
      #v(0.5em)
      #set text(size: sizes.text-s2)
      A full #link("https://amittai.studio/projects", highlight[projects archive])
      online, with source code on my
      #link("https://github.com/siavava", highlight[personal profile]) and
      #link("https://github.com/lostflux", highlight[archival organization]).
    ]
  ]
]

#cv(sidebar-position: "right", sidebar: sidebar, main-content: main)
