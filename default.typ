
#import "@preview/indenta:0.0.3": fix-indent

#let subjects = (
  БД: (
    name: "Бази даних",
    mentor: (
      name: "Черепанова Ю. Ю.",
      gender: "f",
      degree: "ст. викл. каф. ПІ",
    ),
  ),
)

/// DSTU 3008:2015 Template for NURE
/// -> content
/// - doc (content): Content to apply the template to.
/// - title (string): Title of the document.
/// - authors: List of Author dicts.
/// - mentor: Mentor dict.
/// - include_toc: Include table of contents?
/// - doctype ("lb" | "pz" | "ku"): Document type.
/// - worknumber: Number of the work, can be omitted.
/// - subject: Subject name.
#let conf(
  doc,
  title: [Work Title],
  authors: ((name: "Author Name", variant: 1, group: "Group Name", gender: "m"),),
  include_toc: false,
  doctype: "ЛБ",
  worknumber: 1,
  subject_shorthand: "NONE",
) = {
  // numless header
  let numless(it) = {
    set heading(numbering: none)
    it
  }

  // LaTeX-like vfill shorthand
  let vfill = () => v(1fr)

  set document(title: title, author: authors.at(0).name)

  set page(
    paper: "a4",
    margin: (top: 20mm, right: 10mm, bottom: 20mm, left: 25mm),
    number-align: top + right,
    numbering: (..numbers) => {
      if numbers.pos().at(0) != 1 {
        numbering("1", numbers.pos().at(0))
      }
    },
  )

  set text(font: "Times New Roman", size: 14pt, hyphenate: false, lang: "ua")
  set par(justify: true, first-line-indent: 1.25cm)

  // set 1.5 line spacing
  let spacing = 0.95em
  set block(spacing: spacing)
  set par(spacing: spacing)
  set par(leading: spacing)

  // enums and lists
  let ua_alph(pattern: "а)") = {
    // INFO: This alphabet is not full, maybe it should be extended or maybe not.
    //       I cant remember nor find proper formatting rules.
    //       "абвгґдеєжзиіїйклмнопрстуфхцчшщьюя" (full alphabet)

    let alphabet = "абвгдежиклмнпрстуфхцшщюя".split("")

    i => {
      let letter = alphabet.at(i)
      let str = ""
      for char in pattern {
        if char == "а" {
          str += letter
        } else if char == "А" {
          str += upper(letter)
        } else {
          str += char
        }
      }
      str
    }
  }

  set enum(numbering: ua_alph(pattern: "а)"), indent: 1.25cm, body-indent: 0.5cm)
  show enum: it => {
    set enum(indent: 0em, numbering: "1)")
    it
  }

  set list(indent: 1.35cm, body-indent: 0.5cm, marker: [--])

  // figures
  set figure.caption(separator: [ -- ])

  let fig = counter("figure")
  let tab = counter("table")

  show figure.where(kind: image): set figure(
    numbering: (..) => {
      fig.step()
      context str(counter(heading).get().at(0) + worknumber - 1) + "." + context fig.display()
    },
  )
  show figure.where(kind: table): set figure(
    numbering: (..) => {
      tab.step()
      context str(counter(heading).get().at(0) + worknumber - 1) + "." + context tab.display()
    },
  )

  // TODO: Maybe this will be better. Must be investigated.
  //
  // set math.equation(numbering: (..num) =>
  //   numbering("(1.1)", counter(heading).get().first(), num.pos().first())
  // )
  // set figure(numbering: (..num) =>
  //   numbering("1.1", counter(heading).get().first(), num.pos().first())
  // )

  show figure: it => {
    v(spacing * 2, weak: true)
    it
    v(spacing * 2, weak: true)
  }

  // headings
  // set heading(numbering: "1.1")

  // HACK: I can't set initial value for headers counter, so change is only visual. If this style is changed do not forget to fix images and tables numbering as well.
  set heading(numbering: (n1, ..x) => numbering("1.1", n1 - 1 + worknumber, ..x))


  show heading.where(level: 1): it => {
    set align(center)
    set text(size: 14pt, weight: "semibold")

    pagebreak(weak: true)

    block(width: 100%, spacing: 0em)[ #upper(it) ]
  }
  show heading.where(level: 2): it => {
    set text(size: 14pt, weight: "regular")

    block(width: 100%, spacing: 0em)[
      #h(1.25cm)
      #counter(heading).display(it.numbering)
      #it.body
    ]
  }

  let fix-spacings() = doc => {
    if not doc.has("children") { return doc }

    let elems = doc.children.filter(x => x != [ ] and x.func() != parbreak)

    let is_heading = e => e != none and e.func() == heading

    for (i, elem) in elems.enumerate() {
      if not is_heading(elem) {
        elem
        continue
      }

      let prev_elem = elems.at(i - 1, default: none)
      let next_elem = elems.at(i + 1, default: none)

      if elem.depth == 2 {
        v(spacing * (if not is_heading(prev_elem) { 2 } else { 1 }), weak: true)
      }

      elem

      v(spacing * (if not is_heading(next_elem) { 2 } else { 1 }), weak: true)
    }
  }

  show: fix-spacings()
  show: fix-indent()

  if doctype in ("ЛБ", "ПЗ") {
    let subject = subjects.at(subject_shorthand, default: "NONE")
    let mentor = subject.mentor

    align(
      center,
      [
        МІНІСТЕРСТВО ОСВІТИ І НАУКИ УКРАЇНИ

        ХАРКІВСЬКИЙ НАЦІОНАЛЬНИЙ УНІВЕРСИТЕТ РАДІОЕЛЕКТРОНІКИ

        #linebreak()

        Кафедра Програмної інженерії

        #linebreak()
        #linebreak()
        #linebreak()

        Звіт

        з
        #if doctype == "ЛБ" { [лабораторної роботи] } else { [практичної роботи] }
        #if worknumber != none { [№ #worknumber] }

        з дисципліни: "#subject.name"

        з теми: "#title"

        #linebreak()
        #linebreak()
        #linebreak()

        #columns(2)[
          #set align(left)

          #if authors.len() == 1 {
            let author = authors.at(0)
            if author.gender == "m" { [Виконав:\ ] } else { [Виконала:\ ] }
            [
              ст. гр. #author.group\
              #author.name\
              #if author.variant != none { [Варіант: №#author.variant] }
            ]
          } else {
            [
              Виконали:\
              ст. гр. #authors.at(0).group\
              #authors.map(a => [ #a.name\ ])
            ]
          }

          #colbreak()
          #set align(right)

          #if mentor.gender == "m" { [Перевірив:\ ] } else { [Перевірила:\ ] }
          #mentor.degree #if mentor.degree.len() >= 15 {
            [\
            ]
          }
          #mentor.name\
        ]

        #vfill()

        Харків -- #datetime.today().display("[year]")
      ],
    )
  } else if doctype == "КУ" { }

  if include_toc {
    outline(
      title: [
        ЗМІСТ
        #v(spacing * 2)
      ],
      depth: 2,
      indent: auto,
    )
  }

  doc
}
