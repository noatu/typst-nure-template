// SPDX-License-Identifier: GPL-3.0
/*
 * typst-nure-template/template.typ
 *
 * Typst templates for NURE (Kharkiv National University of Radio Electronics) works
 */

#import "style.typ": spacing, dstu-style, appendices-style

// Practice and Laboratory works template {{{

/// DSTU 3008:2015 Template for NURE
/// -> content
/// - it (content): Content to apply the template to.
/// - department (str): Education program name.
/// - work_type (str): Work type, i.e. "з лабораторної роботи".
/// - number (int | none): Number of the work. Optional.
/// - subject (str): Subject name.
/// - title (str | none): Title of the work and the document. Optional.
/// - variant (int | none): Variant of the work. Optional.
/// - author ((name: str, group: (str | none), gender: ("m" | "f" | none)),):
///   A dictionary of one author or an array of authors. Other types will be just displayed.
/// - mentor ((name: str, degree: (str | none), gender: ("m" | "f" | none)),):
///   A dictionary of one mentor or an array of mentors. Other types will be just displayed.
#let general(
  it,
  department: none,
  work_type: none,
  number: none,
  subject: none,
  title: none,
  variant: none,
  author: none,
  mentor: none,
  year: datetime.today().display("[year]"),
) = {
  assert.ne(department, none, message: "Missing argument: \"department\"")
  assert.ne(work_type, none, message: "Missing argument: \"work_type\"")
  assert.ne(subject, none, message: "Missing argument: \"subject\"")

  if type(author) == array and author.len() == 1 { author = author.at(0) }
  if type(mentor) == array and mentor.len() == 1 { mentor = mentor.at(0) }

  set document(
    title: title,
    author: if type(author) == array {
      author.map(a => a.name)
    } else if type(author) == dictionary { author.name } else { "" },
  )

  show: dstu-style.with(skip: 1)

  align(center)[
    МІНІСТЕРСТВО ОСВІТИ І НАУКИ УКРАЇНИ

    ХАРКІВСЬКИЙ НАЦІОНАЛЬНИЙ УНІВЕРСИТЕТ РАДІОЕЛЕКТРОНІКИ
    \ \ \

    Кафедра #department
    \ \ \ \

    Звіт

    #work_type #if number != none [
      №#number
      #counter(heading).update(number - if title != none { 1 } else { 0 })
    ]

    з дисципліни: "#subject"

    #if title != none [з теми: "#title"]

    \ \ \ \

    #columns(2)[
      #set par(first-line-indent: 0pt)
      //
      #set align(left)
      //
      #if type(author) == dictionary [
        #if "gender" in author and author.gender != none {
          if author.gender == "m" [Виконав:] else [Виконала:]
        } else [Виконали:]

        #if "group" in author [ст. гр. #author.group\ ]
        #author.name\
        #if variant != none [Варіант: №#variant]
      ] else if type(author) == array [
        Виконали:

        #for a in author [
          #if "group" in a [ст. гр. #a.group\ ]
          #a.name\
        ]
        #if variant != none [Варіант: №#variant]
      ] else { author } // custom formatting
      //
      #colbreak()
      //
      #set align(right)
      //
      #if type(mentor) == dictionary [
        #if "gender" in mentor and mentor.gender != none {
          if mentor.gender == "m" [Перевірив:] else [Перевірила:]
        } else [Перевірили:]

        #if "degree" in mentor and mentor.degree != none [#mentor.degree\ ]
        #mentor.name
      ] else if type(mentor) == array [
        Перевірили:

        #for m in mentor [
          #if "degree" in m [#m.degree\ ]
          #m.name\
        ]
      ] else { mentor } // custom formatting
    ]
    #v(1fr)
    Харків -- #year
  ]

  pagebreak(weak: true)

  if title != none { heading(title) }

  it
} // }}}

// vim:sts=2:sw=2:fdl=0:fdm=marker:cms=/*%s*/
