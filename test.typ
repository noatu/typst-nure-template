
#import "@preview/indenta:0.0.3": fix-indent

#let subjects = (
  "БД": (
    name: "Бази даних",
    mentors: (
      (
        name: "Черепанова Ю. Ю.",
        gender: "f",
        degree: "Ст. викл. каф. ПІ",
      ),
      (
        name: "Русакова Н. Є.",
        gender: "f",
        degree: "Доц. каф. ПІ",
      ),
      (
        name: "Широкопетлєва М. С.",
        gender: "f",
        degree: "Ст. викл. каф. ПІ",
      ),
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
  authors: (
    (
      name: "Ситник Є. С.",
      full_name_gen: "Ситника Єгора Сергійовича",
      variant: 14,
      group: "ПЗПІ-23-2",
    )
  ),
  title: "Інформаційна система «Помічник класного керівника». Керування класом",
  worknumber: 1,
  doctype: "ЛБ",
  subject_shorthand: "БД",
  department: "Програмної інженерії",
  edu_program: (
    name: "Інженерія програмного забезпечення",
    number: 121,
  ),
  task_list: (
    done_date: datetime(year: 2024, month: 12, day: 27),
    initial_data: datetime(year: 2024, month: 9, day: 15),
    source: "методичні вказівки до виконання курсової роботи, вимоги до інформаційної системи, предметна область, що пов’язана з управлінням класом та класним керівництвом.",
    content: "вступ, аналіз предметної області; постановка задачі; проектування бази даних; опис програми; висновки; перелік джерел посилання.",
    graphics: "загальна діаграма класів, ER-діаграма, UML-діаграми, DFD-діаграма, схема БД в 1НФ, 2НФ, 3НФ, копії екранів (“скриншоти”) прикладної програми, приклади звітів прикладної програми.",
  ),
  calendar_plan: (
    plan_table: [],
    approval_date: datetime(year: 2024, month: 12, day: 27),
  ),
  abstract: (
    keywords: (
      "БАЗА ДАНИХ",
      "АВТОМАТИЗАЦІЯ",
      "КЛАСНИЙ КЕРІВНИК",
      "КЛАС",
      "ШКОЛА",
      "GO",
      "HTMX",
      "MYSQL",
      "SQL",
    ),
    text: [
      Мета даної роботи – проєктування та розробка інформаційної системи «Помічник класного керівника. Керування класом», яка спрямована на автоматизацію процесів управління класом, облік даних про учнів, планування та аналіз навчального процесу. Основна задача інформаційної системи – спростити роботу класного керівника, забезпечити ефективну організацію документації та взаємодію з учасниками освітнього процесу.

      Для реалізації системи було використано сучасний стек технологій, а саме: Go – як основна мова програмування для створення серверної логіки, HTMX – для динамічного оновлення інтерфейсу без використання складних фреймворків, MySQL – як СУБД для зберігання даних про учнів, їх оцінки та розклад, Neovim – як середовище для швидкої та ефективної розробки коду, Go Echo – веб-фреймворк для створення REST API, Go SQLx – бібліотека для роботи з базою даних, що забезпечує зручність і гнучкість.

      Результат роботи – веб-додаток, який дозволяє обліковувати особисті дані учнів та їхніх опікунів, включаючи інформацію про успішність, відвідуваність та інші показники; планувати розклад занять; генерувати звіти про успішність учнів та переглядати різну статистику. Інтерфейс, створений з використанням HTMX, легко адаптується під потреби користувача.
    ],
  ),
  include_toc: true,
) = {
  // LaTeX-like vfill/hfill shorthands
  let vfill = () => v(1fr)
  let hfill(width) = box(width: width, repeat(" ")) // NOTE: This is a HAIR SPACE (U+200A ), not a regular space

  set underline(evade: false)

  let uline(align: center, content) = {
    underline([
      #if align != left { hfill(1fr) }
      #content
      #if align != right { hfill(1fr) }
    ])
  }

  // other shorthands
  let bold(it) = text(weight: "bold")[#it]

  let month_gen(month) = (
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

    let elems = doc.children.filter(x => x != [ ])

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

  let subject = subjects.at(subject_shorthand, default: "NONE")

  if doctype in ("ЛБ", "ПЗ") {
    let mentor = subject.mentors.at(0)
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
  } else if doctype == "КУ" {
    let head_mentor = subject.mentors.at(0)
    let author = authors.at(0)

    // page 1 {{{
    align(center)[
      МІНІСТЕРСТВО ОСВІТИ І НАУКИ УКРАЇНИ

      ХАРКІВСЬКИЙ НАЦІОНАЛЬНИЙ УНІВЕРСИТЕТ РАДІОЕЛЕКТРОНІКИ

      #linebreak()

      Кафедра Програмної інженерії

      #linebreak()

      ПОЯСНЮВАЛЬНА ЗАПИСКА

      ДО КУРСОВОЇ РОБОТИ

      з дисципліни: "#subject.name"

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
        #for mentor in subject.mentors {
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
        #for mentor in subject.mentors {
          [#mentor.name\
          ]
        }
      ]

      #vfill()

      Харків -- #datetime.today().display("[year]")

      #pagebreak()
    ]
    // }}}

    // page 2 {{{
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
        uline(align: left, department)
        linebreak()
        uline(align: left, subject.name)
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
    // }}}

    // page 3 {{{
    heading(numbering: none, depth: 1, [Календарний план])

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

    // }}}

    // page 4 {{{
    [
      #heading(numbering: none, depth: 1, [Реферат])

      Пояснювальна записка до курсової роботи:
      #context [ #counter(page).final().at(0) ] с.,
      #context [ #counter("table").final().at(0) ] табл.,
      #context [ #counter("image").final().at(0) ] рис.,
      #context [ #counter(bibliography).final().at(0) ] джерел.

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
  }

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

#show: conf.with(
  authors: (
    (name: "Ситник Є. С.", full_name_gen: "Ситника Єгора Сергійовича", variant: 15, group: "ПЗПІ-23-2", gender: "m"),
  ),
  title: "Інформаційна система «Помічник класного керівника». Керування класом",
  include_toc: true,
  doctype: "КУ",
  subject_shorthand: "БД",
)

