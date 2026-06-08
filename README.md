# resume

A Typst curriculum vitæ (and, soon, a shorter résumé) built from a single,
shared data source.

## Structure

```
resume/
├── data.yaml          ← single source of truth: all of a person's content
├── Makefile           ← builds both documents
├── vitae/             ← the long-form curriculum vitæ
│   ├── cv.typ         ← document structure only (which sections, in what order)
│   ├── render.typ     ← maps data.yaml → styled content
│   ├── template.typ   ← styling primitives (fonts, colours, section headings…)
│   ├── fonts/         ← vendored fonts (TeX Gyre Pagella + Latin Modern Mono)
│   └── Makefile
└── resume/            ← the compact, one-page résumé
    ├── resume.typ     ← reads /data.yaml; built on the `lavandula` template
    ├── fonts/         ← Fira Sans + Font Awesome 7 Desktop (Free)
    └── Makefile
```

Both documents read the **same** `data.yaml`. The CV is exhaustive and set in
TeX Gyre Pagella; the résumé selects a subset, themed to the CV's maroon, and
lays it out as a two-column page using the
[`lavandula`](https://typst.app/universe/package/lavandula) template (Fira Sans
+ Font Awesome icons). Edit `data.yaml` once and rebuild to update both.

The résumé's fonts are vendored under `resume/fonts/` (and installed
system-wide). The `lavandula` and `fontawesome` packages are fetched
automatically by Typst on first build.

The three layers are independent:

- **`data.yaml`** — the facts. To rebuild this CV for someone else, edit *only*
  this file.
- **`template.typ`** — how things look. Edit to restyle.
- **`cv.typ` / `render.typ`** — how the data is laid out and mapped to styling.

## Building

```sh
make                      # both -> vitae/cv.pdf and resume/resume.pdf
make -C vitae             # just the CV
make -C resume            # just the résumé
make -C vitae watch       # live-rebuild on save
```

`make` sets the Typst project root to this repository so that
`yaml("/data.yaml")` resolves. If you build by hand, do the same:

```sh
typst compile --root .. --font-path fonts cv.typ cv.pdf
```

When editing in an IDE, open this repository folder (not `vitae/`) as the
workspace so the Typst language server uses it as the project root.

## Editing the data

Keys are dash-case (e.g. `other-information`, `location-short`). Long prose
fields use YAML literal block scalars (`|`), so you can wrap lines freely
without quotes or escaping — they fold back into one paragraph when rendered.
A few of them (experience summaries and bullets, the publications intro, the
"other information" notes) may contain inline Typst markup:

- `_italic_`, `*bold*`, `` `code` ``, and `#highlight[...]`
- links via `#tlink("https://…")[visible text]`
- a literal dollar sign is written `\$` (e.g. `\$15M`)

Everything else — names, dates, course lists, skills — is just plain text.
