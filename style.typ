// SPDX-License-Identifier: GPL-3.0
/*
 * style.typ: Styles beneficial beyond the typst-nure-template
 */

#let spacing = 0.95em // spacing between lines
#let num-to-alpha = "абвгдежиклмнпрстуфхцшщюя".split("") // 0 = "", 1 = "а"

/// DSTU 3008:2015 Style
/// -> content
/// - it (content): Content to apply the style to.
/// - skip (int): Do not show page number for this number of pages.
/// - offset (int): Adjust all page numbers by this amount.
#let dstu-style(
  it,
  skip: 0,
  offset: 0,
) = {
  // General Styling {{{1
  set page(
    paper: "a4",
    number-align: top + right,
    margin: (top: 20mm, right: 10mm, bottom: 20mm, left: 25mm),
    numbering: (i, ..) => if i > skip { numbering("1", i + offset) },
  )

  set text(
    lang: "uk",
    size: 14pt,
    hyphenate: false,
    font: ("Times New Roman", "Liberation Serif"),
  )

  set par(
    justify: true,
    spacing: spacing,
    leading: spacing,
    first-line-indent: (amount: 1.25cm, all: true),
  )

  set block(spacing: spacing)
  set underline(evade: false)

  // Enums & Lists {{{1
  // First level
  set enum(
    indent: 1.25cm,
    body-indent: 0.5cm,
    numbering: i => { num-to-alpha.at(i) + ")" },
  )

  // Second level and further nesting
  show enum: it => {
    set enum(indent: 0em, numbering: "1)")
    it
  }

  // Lists are not intended for multiple levels, use `enum`
  set list(indent: 1.35cm, body-indent: 0.5cm, marker: [--])

  // Figures {{{1
  show figure: it => {
    v(spacing * 2, weak: true)
    it
    v(spacing * 2, weak: true)
  }

  set figure.caption(separator: [ -- ])
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption.where(kind: table): set align(left)

  // Numbering
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: raw)).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    it
  }
  set figure(numbering: i => numbering("1.1", counter(heading).get().at(0), i))
  set math.equation(numbering: i => numbering("(1.1)", counter(heading).get().at(0), i))

  // References to images and tables {{{1
  // TODO: simplify this to a simple number display? Will become a bit manual tho
  set ref(
    supplement: it => if it == none or not it.has("kind") {
      it
    } else if it.kind == image {
      "див. рис."
    } else if it.kind == table {
      "див. таблицю"
    } else {
      it
    },
  )
  show ref: it => {
    let el = it.element

    if el == none or not el.has("kind") {
      return it
    }
    if el.kind != image and el.kind != table {
      return it
    }

    [(#it)]
  }

  // Headings {{{1
  set heading(numbering: "1.1")

  show heading: it => if it.level == 1 {
    set align(center)
    set text(size: 14pt, weight: "semibold")

    pagebreak(weak: true)
    upper(it)
    v(spacing * 2, weak: true)
  } else {
    set text(size: 14pt, weight: "regular")

    v(spacing * 2, weak: true)
    block(width: 100%, spacing: 0em)[
      #h(1.25cm)
      #counter(heading).display(auto)
      #it.body
    ]
    v(spacing * 2, weak: true)
  }


  // Listings {{{1
  show raw: it => {
    let raw-spacing = 0.5em
    set block(spacing: raw-spacing)
    set par(spacing: raw-spacing, leading: raw-spacing)
    set text(
      size: 11pt,
      weight: "semibold",
      font: ("Courier New", "Liberation Mono"),
    )

    v(spacing * 2.5, weak: true)
    pad(it, left: 1.25cm)
    v(spacing * 2.5, weak: true)
  }

  it
  // }}}
}

/// DSTU 3008:2015 Appendices Style
/// -> content
/// - it (content): Content to apply the style to.
#let appendices-style(it) = /* {{{ */ {
  counter(heading).update(0)
  set heading(numbering: (i, ..n) => upper(num-to-alpha.at(i)) + numbering(".1.1", ..n))

  show heading: it => if it.level == 1 {
    set align(center)
    set text(size: 14pt, weight: "regular")

    pagebreak(weak: true)
    text(weight: "bold")[ДОДАТОК #counter(heading).display(auto)]
    linebreak()
    it.body
    v(spacing * 2, weak: true)
  } else {
    set text(size: 14pt, weight: "regular")

    v(spacing * 2, weak: true)
    block(width: 100%, spacing: 0em)[
      #h(1.25cm)
      #counter(heading).display(auto)
      #it.body
    ]
    v(spacing * 2, weak: true)
  }

  it
} // }}}

// vim:sts=2:sw=2:fdl=0:fdm=marker:cms=/*%s*/
