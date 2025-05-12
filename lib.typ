// SPDX-License-Identifier: GPL-3.0
/*
 * typst-nure-template/lib.typ
 *
 * Typst template for NURE (Kharkiv National University of Radio Electronics) works
 */

#import "style.typ": spacing, dstu-style, appendices-style

// Academic aliases {{{1

#let universities = yaml("config/universities.yaml")

// Template formatting functions {{{1

/// numberless heading
#let nheading(title) = heading(depth: 1, numbering: none, title)

/// fill horizontal space with a box and not an empty space
#let hfill(width) = box(
  width: width,
  repeat(" "),
) // NOTE: This is a HAIR SPACE (U+200A), not a regular space

/// make underlined cell with filled value
#let uline(align: center, content) = underline[
  #if align != left { hfill(1fr) }
  #content
  #if align != right { hfill(1fr) }
]

/// bold text
#let bold(content) = text(weight: "bold")[#content]

/// month name from its number
#let month_gen(month) = (
  "січня",
  "лютого",
  "березня",
  "квітня",
  "травня",
  "червня",
  "липня",
  "серпня",
  "вересня",
  "жовтня",
  "листопада",
  "грудня",
).at(month - 1)

// Helper functions {{{1

/// captioned image with label derived from path:
/// - "image.png" = @image
/// - "img/image.png" = @image
/// - "img/foo/image.png" = @foo_image
/// - "img/foo/foo_image.png" = @foo_image
/// the caption will be modified based on a conditional positional value:
/// - `none`: no change
/// - some value: "`caption` (за даними `value`)"
/// - no value: "`caption` (рисунок виконано самостійно)"
/// additional named arguments will be passed to original `image` function
#let img(path, caption, ..sink) = {
  let parts = path.split(".").first().split("/")

  let label_string = if (
    parts.len() <= 2 or parts.at(-1).starts-with(parts.at(-2))
  ) {
    // ("image",), (_, "image") and (.., "img", "img_image")
    parts.last()
  } else {
    // (.., "img", "image") = "img_image"
    parts.at(-2) + "_" + parts.at(-1)
  }.replace(" ", "_")

  let caption = if sink.pos().len() == 0 {
    caption + " (рисунок виконано самостійно)"
  } else if sink.pos().first() == none {
    caption
  } else {
    [#caption (за даними #sink.pos().first())]
  }

  [#figure(
      image(path, ..sink.named()),
      caption: caption,
    ) #label(label_string)]
}

// Coursework template {{{1

/// DSTU 3008:2015 Template for NURE
/// -> content
/// - doc (content): Content to apply the template to.
/// - title (str): Title of the document.
/// - subject (str): Subject short name.
/// - authors ((name: str, full_name_gen: str, variant: int, course: int, semester: int, group: str, gender: str),): List of authors.
/// - mentors ((name: str, degree: str),): List of mentors.
/// - edu_program (str): Education program shorthand.
/// - task_list (done_date: datetime, initial_date: datetime, source: (content | str), content: (content | str), graphics: (content | str)): Task list object.
/// - calendar_plan ( plan_table: (content | str), approval_date: datetime): Calendar plan object.
/// - abstract (keywords: (str, ), text: (content | str)): Abstract object.
/// - bib_path path: Path to the bibliography yaml file.
/// - appendices (content): Content with appendices.
#let coursework(
  doc,
  title: none,
  subject: none,
  university: "ХНУРЕ",
  author: (),
  mentors: (),
  edu_program: none,
  task_list: (),
  calendar_plan: (),
  abstract: (),
  bib_path: none,
  appendices: (),
) = {
  set document(title: title, author: author.name)

  show: dstu-style.with(skip: 1)

  let bib-count = state("citation-counter", ())
  show cite: it => {
    it
    bib-count.update(((..c)) => (..c, it.key))
  }
  show bibliography: it => {
    set text(size: 0pt)
    it
  }


  let head_mentor = mentors.at(0)
  let uni = universities.at(university)
  let edu_prog = uni.edu_programs.at(edu_program)

  // page 1 {{{2
  [
    #set align(center)
    МІНІСТЕРСТВО ОСВІТИ І НАУКИ УКРАЇНИ\
    #upper(uni.name)

    \

    Кафедра #edu_prog.department_gen

    \

    ПОЯСНЮВАЛЬНА ЗАПИСКА\
    ДО КУРСОВОЇ РОБОТИ\
    з дисципліни: "#uni.subjects.at(subject, default: "NONE")"\
    Тема роботи: "#title"

    \ \ \

    #columns(2, gutter: 4cm)[
      #set align(left)

      #if author.gender == "m" { [Виконав\ ] } else { [Виконала\ ] } ст. гр. #edu_program\-#author.group

      \
      Керівник:\
      #head_mentor.degree

      \
      Робота захищена на оцінку

      \
      Комісія:\
      #for mentor in mentors {
        [#mentor.degree\
        ]
      }

      #colbreak()
      #set align(left)

      \
      #author.name

      \ \
      #head_mentor.name

      \
      #underline(" " * 35)

      \ \
      #for mentor in mentors {
        [#mentor.name\
        ]
      }
    ]

    #v(1fr)

    Харків -- #task_list.done_date.display("[year]")

    #pagebreak()
  ]

  // page 2 {{{2
  {
    uline[#uni.name]

    linebreak()
    linebreak()

    grid(
      columns: (100pt, 1fr),
      bold[
        Кафедра
        Дисципліна
        Спеціальність
      ],
      {
        uline(align: left, edu_prog.department_gen)
        linebreak()
        uline(align: left, uni.subjects.at(subject))
        linebreak()
        uline(align: left, [#edu_prog.code #edu_prog.name_long])
      },
    )
    grid(
      columns: (1fr, 1fr, 1fr),
      gutter: 0.3fr,
      [#bold[Курс] #uline(author.course)],
      [#bold[Група] #uline([#edu_program\-#author.group])],
      [#bold[Семестр] #uline(author.semester)],
    )

    linebreak()
    linebreak()
    linebreak()

    align(center, bold[ЗАВДАННЯ \ на курсову роботу студента])

    linebreak()

    uline(align: left)[_#author.full_name_gen _]

    linebreak()
    linebreak()

    bold[\1. Тема роботи:]
    uline[#title.]

    linebreak()

    {
      bold[\2. Строк здачі закінченої роботи:]
      uline(task_list.done_date.display("[day].[month].[year]"))
      hfill(10fr)
    }

    linebreak()

    bold[\3. Вихідні дані для роботи:]
    uline(task_list.source)

    linebreak()

    bold[\4. Зміст розрахунково-пояснювальної записки:]
    uline(task_list.content)

    linebreak()

    bold[\5. Перелік графічного матеріалу:]
    uline(task_list.graphics)

    linebreak()

    {
      bold[\6. Дата видачі завдання:]
      uline(task_list.initial_date.display("[day].[month].[year]"))
      hfill(10fr)
    }

    pagebreak()
  }

  // page 3 {{{2
  {
    align(center, bold[КАЛЕНДАРНИЙ ПЛАН])
    set par(first-line-indent: 0pt)

    linebreak()

    calendar_plan.plan_table

    linebreak()

    grid(
      columns: (5fr, 5fr),
      grid(
        columns: (1fr, 2fr, 1fr),
        gutter: 0.2fr,
        [
          Студент \
          Керівник \
          #align(center)["#underline[#calendar_plan.approval_date.day()]"]
        ],
        [
          #uline(align: center, []) \
          #uline(align: center, []) \
          #uline(align: center, month_gen(calendar_plan.approval_date.month()))
        ],
        [
          \ \
          #underline[#calendar_plan.approval_date.year()] р.
        ],
      ),
      [
        #author.name, \
        #head_mentor.degree
        #head_mentor.name.
      ],
    )

    pagebreak()
  }

  // page 4 {{{2
  [
    #align(center, bold[РЕФЕРАТ]) \

    #context [
      #let pages = counter(page).final().at(0)
      #let images = query(figure.where(kind: image)).len()
      #let tables = query(figure.where(kind: table)).len()
      #let bibs = bib-count.final().dedup().len()
      /* TODO: why this stopped working?
      #let tables = counter(figure.where(kind: table)).final().at(0)
      #let images = counter(figure.where(kind: image)).final().at(0)*/

      #let counters = ()

      #if pages != 0 { counters.push[#pages с.] }
      #if tables != 0 { counters.push[#tables табл.] }
      #if images != 0 { counters.push[#images рис.] }
      #if bibs != 0 { counters.push[#bibs джерел] }

      Пояснювальна записка до курсової роботи: #counters.join(", ").
    ]

    \

    #{
      let keywords = abstract.keywords.map(upper)
      let is_cyrillic = word => word.split("").any(char => ("А" <= char and char <= "я"))

      let n = keywords.len()
      for i in range(n) {
        for j in range(0, n - i - 1) {
          if (
            (
              not is_cyrillic(keywords.at(j)) and is_cyrillic(keywords.at(j + 1))
            )
              or (
                is_cyrillic(keywords.at(j)) == is_cyrillic(keywords.at(j + 1))
                  and keywords.at(j) > keywords.at(j + 1)
              )
          ) {
            (keywords.at(j), keywords.at(j + 1)) = (
              keywords.at(j + 1),
              keywords.at(j),
            )
          }
        }
      }

      keywords.join(", ")
    }

    \

    #abstract.text
  ]

  // page 5 {{{2
  outline(
    title: [
      ЗМІСТ
      #v(spacing * 2, weak: true)
    ],
    depth: 2,
    indent: auto,
  )

  doc

  // bibliography {{{2
  {
    heading(depth: 1, numbering: none)[Перелік джерел посилання]

    bibliography(
      bib_path,
      style: "ieee",
      full: true,
      title: none,
    )

    let bib_data = yaml(bib_path)

    let format-entry(citation) = {
      if (citation.type == "Web") {
        let date_array = citation.url.date.split("-")
        let date = datetime(
          year: int(date_array.at(0)),
          month: int(date_array.at(1)),
          day: int(date_array.at(2)),
        )
        [
          #citation.title.
          #citation.author.
          URL: #citation.url.value (дата звернення: #date.display("[day].[month].[year]")).
        ]
      } else if citation.type == "Book" [
        #citation.author
        #citation.title.
        #citation.publisher,
        #citation.date.
        #citation.page-total c.
      ] else [
        UNSUPPORTED BIBLIOGRAPHY ENTRY TYPE, PLEASE OPEN AN ISSUE
      ]
    }

    show enum.item: it => {
      set par(first-line-indent: 0pt)
      box(width: 1.25cm)
      box(width: 1em + 0.5cm)[#it.number.]
      it.body
      linebreak()
    }

    context {
      for (i, citation) in query(ref.where(element: none))
        .map(r => str(r.target))
        .dedup()
        .enumerate() {
        enum.item(
          i + 1,
          format-entry(bib_data.at(citation)),
        )
      }
    }
  }

  appendices-style(appendices)
}

// Practice and Laboratory works template {{{1

/// DSTU 3008:2015 Template for NURE
/// -> content
/// - doc (content): Content to apply the template to.
/// - doctype ("ЛБ" | "ПЗ"): Document type.
/// - edu_program (str): Education program shorthand.
/// - title (str): Title of the document.
/// - subject (str): Subject shorthand.
/// - authors ((name: str, full_name_gen: str, group: str, gender: str, variant: int or none),): List of authors.
/// - mentors ((name: str, degree: str, gender: str or none),): List of mentors.
/// - worknumber (int or none): Number of the work. Optional.
#let pz-lb(
  doc,
  doctype: none,
  university: "ХНУРЕ",
  edu_program: none,
  title: none,
  subject: none,
  worknumber: none,
  authors: (),
  mentors: (),
) = {
  set document(title: title, author: authors.at(0).name)

  show: dstu-style.with(skip: 1)

  let uni = universities.at(university)
  let edu_prog = uni.edu_programs.at(edu_program)
  // page 1 {{{2
  align(center)[
    МІНІСТЕРСТВО ОСВІТИ І НАУКИ УКРАЇНИ \
    #upper(uni.name)

    \ \
    Кафедра #edu_prog.department_gen

    \ \ \
    Звіт \
    з
    #if doctype == "ЛБ" [лабораторної роботи] else [практичної роботи]
    #if worknumber != none {
      context counter(heading).update(worknumber - if title == none { 0 } else { 1 })
      [№#worknumber]
    }

    з дисципліни: "#uni.subjects.at(subject, default: "UNKNOWN SUBJECT, PLEASE OPEN AN ISSUE")"

    #if title != none [з теми: "#title"]

    \ \ \ \

    #columns(2)[
      #set align(left)
      #set par(first-line-indent: 0pt)
      #if authors.len() == 1 {
        let author = authors.at(0)
        if author.gender == "m" [Виконав:\ ] else [Виконала:\ ]
        [
          ст. гр. #edu_program\-#author.group\
          #author.name\
        ]
        if "variant" in author.keys() and author.variant != none [Варіант: №#author.variant]
      } else [
        Виконали:\
        ст. гр. #edu_program\-#authors.at(0).group\
        #for author in authors [#author.name\ ]
      ]

      #colbreak()
      #set align(right)

      #if mentors.len() == 1 {
        let mentor = mentors.at(0)
        if mentor.gender == none [Перевірили:\ ] else if (
          mentor.gender == "m"
        ) [Перевірив:\ ] else [Перевірилa:\ ]
        [
          #if mentor.degree != none [#mentor.degree\ ]
          #mentor.name\
        ]
      } else [
        Перевірили:\
        #for mentor in mentors {
          [
            #mentor.degree\
            #mentor.name\
          ]
        }
      ]
    ]

    #v(1fr)

    Харків -- #datetime.today().display("[year]")
  ]

  pagebreak(weak: true)

  if title != none [#heading(title)]

  doc
}

// vim:sts=2:sw=2:fdl=0:fdm=marker:cms=/*%s*/
