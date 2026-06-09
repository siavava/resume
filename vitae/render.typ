// ─────────────────────────────────────────────────────────────────────────
//  Render layer: turns the plain data in data.yaml into styled content using
//  the primitives from template.typ. Nothing here is specific to one person —
//  point it at a different data.yaml and it renders that person's CV.
//
//  Most fields are plain strings rendered verbatim. A few free-form prose
//  fields (experience summaries and bullets, the publications intro, the
//  "other information" notes) may contain inline Typst markup — emphasis with
//  _.._ / *..*, inline code with `..`, and links via #tlink("url")[text]. Those
//  fields are evaluated through `md()` below. In them, a literal dollar sign is
//  written \$ (e.g. \$15M); YAML block scalars need no further escaping.
// ─────────────────────────────────────────────────────────────────────────

#import "template.typ": *

// Evaluate a string as Typst markup, exposing the link helpers to it. The
// .trim() drops the trailing newline that literal block scalars ( | ) carry.
#let md(body) = eval(
  body.trim(),
  mode: "markup",
  scope: (tlink: tlink, weblink: weblink, mono: mono),
)

#let render-personal(p) = {
  let pairs = (
    ([Name], [#p.name.]),
    ([Location], [#p.location.]),
    ([Phone], [#p.phone]),
  ) + p.contacts.map(c => (c.label, weblink(c.url, c.display)))
  datablock(..pairs)
}

#let render-education(e) = {
  subsection[Undergraduate studies]
  datablock(
    ([Institution], [#tlink(e.institution.url, e.institution.name). #e.location.]),
    ([Degree], [#e.degree.]),
    ([Duration], [#e.duration.]),
    ([Honors], [#e.honors.join(" and ").]),
  )
  v(0.8em)
  md(e.at("coursework-intro"))
  enum(..e.coursework.map(c => {
    let label = if "url" in c { tlink(c.url, strong(c.label)) } else { strong(c.label) }
    let body = if "courses" in c {
      c.courses.map(course => tlink(course.url, [#course.name (#course.code)])).join(", ")
    } else { md(c.body) }
    [#label#strong[:] #body]
  }))
  if "other-programs" in e and e.at("other-programs").len() > 0 {
    subsection[Other programs]
    for op in e.at("other-programs") {
      datablock(
        ([Program], [#tlink(op.program.url, op.program.name). #op.dates.]),
        ([], [#md(op.description)]),
      )
    }
  }
}

// Shared header line for an experience / teaching entry:
//   *Role — Org.* Location. Dates.
#let entry-head(x) = [#strong[#x.role — #x.org.] #x.location. #x.dates.]

#let render-experience(items) = {
  for (i, e) in items.enumerate() {
    entry(i + 1)[
      #entry-head(e)

      #md(e.summary)

      #enum(..e.responsibilities.map(md))

      #emph[Technologies:] #e.technologies.
    ]
  }
}

#let render-teaching(items) = {
  for (i, t) in items.enumerate() {
    entry(i + 1)[
      #entry-head(t)

      #md(t.summary)

      #list(..t.courses.map(c => [#tlink(c.url, c.name) (#c.terms).]))
    ]
  }
}

#let render-publications(pubs) = {
  md(pubs.intro)
  enum(..pubs.items.map(p => [#tlink(p.url, strong[#p.title.]) #p.date. #p.description]))
}

#let render-skills(s) = {
  datablock(
    ([Languages], [#s.languages]),
    ([], [#s.at("languages-note")]),
  )
  v(0.7em)
  datablock(
    ([Areas of interest], [#md(s.at("areas-of-interest"))]),
  )
}

#let render-other(items) = list(..items.map(md))
