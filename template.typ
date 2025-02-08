#import "@preview/indenta:0.0.3": fix-indent

#let hfill(width) = box(width: width, repeat(" ")) // NOTE: This is a HAIR SPACE (U+200A ), not a regular space

#let uline(align: center, content) = underline([
  #if align != left { hfill(1fr) }
  #content
  #if align != right { hfill(1fr) }
])

#let bold(content) = text(weight: "bold")[#content]

#let fig(path, caption) = [
  #figure(
    image(path),
    caption: caption,
  )
  #label(path.split("/").last().split(".").first())
]

#let subjects = (
  "БД": "Бази даних",
)

#let edu_programs = (
  "ПЗПІ": (
    name: "Інженерія програмного забезпечення",
    number: 121,
  ),
)

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

#let spacing = 0.95em

/// DSTU 3008:2015 Template for NURE
/// -> content
/// - doc (content): Content to apply the template to.
/// - doctype ("ЛБ" | "ПЗ" | "КП"): Document type.
/// - title (str): Title of the document.
/// - subject_shorthand (str): Subject name.
/// - department_gen (str): Department name in genitive form.
/// - edu_program_number (int): Education program number.
/// - worknumber (int): Number of the work, can be omitted.
/// - authors ((name: str, full_name_gen: str, variant: int, group: str, gender: str),): List of Authors dicts.
/// - task_list (done_date: datetime, initial_data: datetime, source: str, content: str, graphics: str): Task list.
/// - calendar_plan (plan_table: list, approval_date: datetime): Calendar plan.
/// - abstract (keywords: (str,), text: [str,]): Abstract.
#let conf(
  doc,
  title: "NONE",
  doctype: "NONE",
  subject_shorthand: "NONE",
  department_gen: "Програмної інженерії",
  worknumber: 1,
  authors: (),
  mentors: (),
  edu_program: "NONE",
  task_list: (),
  calendar_plan: (),
  abstract: (),
  bib_path: "bibl.yml",
  appendices: (),
) = {
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

  set text(font: "Liberation Serif", size: 14pt, hyphenate: false, lang: "ua")
  set par(justify: true, first-line-indent: 1.25cm)
  set underline(evade: false)

  // set 1.5 line spacing
  set block(spacing: spacing)
  set par(spacing: spacing)
  set par(leading: spacing)

  // enums and lists
  let ua_alph_numbering() = {
    // INFO: This alphabet is not full, maybe it should be extended or maybe not.
    //       I cant remember nor find proper formatting rules.
    //       "абвгґдеєжзиіїйклмнопрстуфхцчшщьюя" (full alphabet)

    let alphabet = "абвгдежиклмнпрстуфхцшщюя".split("")
    i => { alphabet.at(i) + ")" }
  }

  set enum(numbering: ua_alph_numbering(), indent: 1.25cm, body-indent: 0.5cm)
  show enum: it => {
    set enum(indent: 0em, numbering: "1)")
    it
  }

  set list(indent: 1.35cm, body-indent: 0.5cm, marker: [--])

  // citations
  let bib-count = state("citation-counter", ())
  show cite: it => {
    it
    bib-count.update(((..c)) => (..c, it.key))
  }
  let cit = context bib-count.final().dedup().len()

  // figures
  set figure.caption(separator: [ -- ])

  let img = counter("image")
  let tab = counter("table")

  show figure.where(kind: image): set figure(
    numbering: (..) => {
      img.step()
      context str(counter(heading).get().at(0) + worknumber - 1) + "." + context img.display()
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
  // HACK: I can't set initial value for headers counter, so change is only visual. If this style is changed do not forget to fix images and tables numbering as well.
  set heading(numbering: (n1, ..x) => numbering("1.1", n1 - 1 + worknumber, ..x))

  show heading.where(level: 1): it => {
    set align(center)
    set text(size: 14pt, weight: "semibold")

    pagebreak(weak: true)
    upper(it)
    v(spacing * 2, weak: true)
  }
  show heading.where(level: 2): it => {
    set text(size: 14pt, weight: "regular")

    v(spacing * 2, weak: true)
    block(width: 100%, spacing: 0em)[
      #h(1.25cm)
      #counter(heading).display(it.numbering)
      #it.body
    ]
    v(spacing * 2, weak: true)
  }

  show: fix-indent()

  let subject = subjects.at(subject_shorthand, default: "NONE")

  if doctype in ("ЛБ", "ПЗ") {
    let mentor = subject.mentors.at(0)
    align(center)
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
      #if doctype == "ЛБ" [лабораторної роботи] else [практичної роботи]
      #if worknumber != none [№ #worknumber]

      з дисципліни: "#subject.name"

      з теми: "#title"

      #linebreak()
      #linebreak()
      #linebreak()

      #columns(2)[
        #set align(left)

        #if authors.len() == 1 [
          #let author = authors.at(0)
          #if author.gender == "m" { [Виконав:\ ] } else { [Виконала:\ ] }
          ст. гр. #author.group\
          #author.name\
          #if author.variant != none { [Варіант: №#author.variant] }
        ] else [
          Виконали:\
          ст. гр. #authors.at(0).group\
          #authors.map(a => [ #a.name\ ])
        ]

        #colbreak()
        #set align(right)

        #if mentor.gender == "m" { [Перевірив:\ ] } else { [Перевірила:\ ] }
        #mentor.degree #if mentor.degree.len() >= 15 [\ ]
        #mentor.name\
      ]

      #v(1fr)

      Харків -- #datetime.today().display("[year]")
    ]
  } else if doctype == "КП" {
    let head_mentor = mentors.at(0)
    let author = authors.at(0)
    let edu_program = edu_programs.at(edu_program)

    // page 1
    align(center)[
      МІНІСТЕРСТВО ОСВІТИ І НАУКИ УКРАЇНИ

      ХАРКІВСЬКИЙ НАЦІОНАЛЬНИЙ УНІВЕРСИТЕТ РАДІОЕЛЕКТРОНІКИ

      #linebreak()

      Кафедра Програмної інженерії

      #linebreak()

      ПОЯСНЮВАЛЬНА ЗАПИСКА

      ДО КУРСОВОЇ РОБОТИ

      з дисципліни: "#subject"

      Тема роботи: "#title"

      #linebreak()
      #linebreak()
      #linebreak()

      #columns(2, gutter: 4cm)[
        #set align(left)

        #if authors.len() == 1 [
          #if author.gender == "m" { [Виконав\ ] } else { [Виконала\ ] } ст. гр. #author.group
        ]

        #linebreak()
        Керівник:\
        #head_mentor.degree

        #linebreak()
        Робота захищена на оцінку

        #linebreak()
        Комісія:\
        #for mentor in mentors {
          [#mentor.degree\
          ]
        }

        #colbreak()
        #set align(left)

        #linebreak()
        #author.name

        #linebreak()
        #linebreak()
        #head_mentor.name

        #linebreak()
        #underline(" " * 35)

        #linebreak()
        #linebreak()
        #for mentor in mentors {
          [#mentor.name\
          ]
        }
      ]

      #v(1fr)

      Харків -- #datetime.today().display("[year]")

      #pagebreak()
    ]
    //

    // page 2
    {
      uline([Харківський національний університет радіоелектроніки])

      linebreak()
      linebreak()

      grid(
        columns: (100pt, 1fr),
        bold([
          Кафедра
          Дисципліна
          Спеціальність
        ]),
        {
          uline(align: left, department_gen)
          linebreak()
          uline(align: left, subject)
          linebreak()
          uline(align: left, [#edu_program.number #edu_program.name])
        },
      )
      grid(
        columns: (1fr, 1fr, 1fr),
        gutter: 0.3fr,
        [#bold("Курс") #uline(2)], [#bold("Група") #uline(author.group)], [#bold("Семестр") #uline(3)],
      )

      linebreak()
      linebreak()
      linebreak()

      align(center)[#bold([
          ЗАВДАННЯ

          на курсову роботу студента
        ])]

      linebreak()

      uline(align: left)[#emph(author.full_name_gen)]

      linebreak()
      linebreak()

      bold([ #"1. "Тема роботи: ])
      uline([#title.])

      linebreak()

      {
        bold([ #"2. "Строк здачі закінченої роботи: ])
        uline(task_list.done_date.display("[day].[month].[year]"))
        hfill(10fr)
      }

      linebreak()

      bold([ #"3. "Вихідні дані для роботи: ])
      uline(task_list.source)

      linebreak()

      bold([ #"4. "Зміст розрахунково-пояснювальної записки: ])
      uline(task_list.content)

      linebreak()

      bold([ #"5. "Перелік графічного матеріалу: ])
      uline(task_list.graphics)

      linebreak()

      {
        bold([ #"6. "Строк здачі закінченої роботи: ])
        uline(task_list.done_date.display("[day].[month].[year]"))
        hfill(10fr)
      }

      pagebreak()
    }

    // page 3
    {
      align(center)[#bold([КАЛЕНДАРНИЙ ПЛАН])]

      linebreak()

      calendar_plan.plan_table

      linebreak()

      grid(
        columns: (6fr, 5fr),
        grid(
          columns: (1fr, 3fr, 1fr),
          gutter: 0.2fr,
          [
            Студент
            #linebreak()
            Керівник
            #linebreak()
            #align(center, ["#calendar_plan.approval_date.day()"])
          ],
          [
            #uline(align: center, [])
            #linebreak()
            #uline(align: center, [])
            #linebreak()
            #uline(align: center, month_gen(calendar_plan.approval_date.month()))
          ],
          {
            linebreak()
            linebreak()
            [#calendar_plan.approval_date.year() р.]
          },
        ),
        [
          #author.name,
          #linebreak()
          #head_mentor.degree
          #head_mentor.name.
        ],
      )

      pagebreak()
    }

    // page 4 {{{
    [
      #align(center)[#bold([РЕФЕРАТ])]
      #linebreak()

      #context [
        #let pages = counter(page).final().at(0)
        #let tables = counter("table").final().at(0)
        #let images = counter("image").final().at(0)
        #let bibs = bib-count.final().dedup().len()

        #let counters = ()

        #if pages != 0 { counters.push([#pages с.]) }
        #if tables != 0 { counters.push([#tables табл.]) }
        #if images != 0 { counters.push([#images рис.]) }
        #if bibs != 0 { counters.push([#bibs джерел]) }

        Пояснювальна записка до курсової роботи: #counters.join(", ").
      ]

      #linebreak()

      #{
        let keywords = abstract.keywords
        let is_cyrillic = word => word
          .split("")
          .any(char => ("А" <= char and char <= "я") or char == "Ё" or char == "ё")

        let n = keywords.len()
        for i in range(n) {
          for j in range(0, n - i - 1) {
            if (
              (not is_cyrillic(keywords.at(j)) and is_cyrillic(keywords.at(j + 1)))
                or (
                  is_cyrillic(keywords.at(j)) == is_cyrillic(keywords.at(j + 1)) and keywords.at(j) > keywords.at(j + 1)
                )
            ) {
              (keywords.at(j), keywords.at(j + 1)) = (keywords.at(j + 1), keywords.at(j))
            }
          }
        }

        keywords.join(", ")
      }

      #linebreak()

      #abstract.text
    ]
    // }}}

    // page 5 {{{
    show outline.entry: it => {
      show linebreak: none
      it
    }
    outline(
      title: [
        ЗМІСТ
        #v(spacing * 2)
      ],
      depth: 2,
      indent: auto,
    )
    // }}}
  }

  doc

  // bibliography {{{
  show bibliography: it => {
    set text(size: 0pt)
    it
  }

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
        _#{citation.author}_.
        URL: #citation.url.value (дата звернення: #date.display("[day].[month].[year]")).
      ]
    } else if citation.type == "Book" [
      #citation.author
      #citation.title.
      #citation.publisher,
      #citation.date.
      #citation.page-total c.
    ] else [
      UNSUPPORTED BIBLIOGRAPHY ENTRY TYPE, PLEASE OPEN THE ISSUE
    ]
  }

  show enum.item: it => {
    box(width: 1.25cm)
    box(width: 1em + 0.5cm)[#it.number.]
    it.body
    linebreak()
  }

  context {
    let citations = query(ref.where(element: none)).map(r => str(r.target)).dedup()

    for (i, citation) in citations.enumerate() {
      enum.item(
        i + 1,
        format-entry(bib_data.at(citation)),
      )
    }
  }
  // }}}

  // appendices {{{
  counter(heading).update(0)

  for (i, appendix) in appendices.enumerate() [
    #set heading(
      numbering: i => [
        Додаток #"АБВГДЕЖИКЛМНПРСТУФХЦШЩЮЯ".split("").at(i)
      ],
    )

    #show heading: it => {
      set align(center)
      set text(size: 14pt, weight: "regular")
      pagebreak(weak: true)

      bold(upper(counter(heading).display(it.numbering)))

      linebreak()

      it.body

      v(spacing * 2, weak: true)
    }
    = #appendix.title
    #appendix.content
  ]
  // }}}
}
