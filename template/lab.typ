#import "@local/nure:0.1.0": *

#show: pz-lb-template.with(
  doctype: "ЛБ",
  edu_program: "ПЗПІ",
  subject: "БД",
  worknumber: 1,
  title: "Інформаційна система «Помічник класного керівника». Керування класом",
  authors: (
    (
      name: "Ситник Є. С.",
      full_name_gen: "Ситника Єгора Сергійовича",
      variant: 13,
      group: "ПЗПІ-23-2",
      gender: "m",
    ),
  ),
  mentors: (
    (name: "Черепанова Ю. Ю.", degree: "Ст. викл. каф. ПІ", gender: "f"),
  ),
)

#v(-spacing)

== Мета роботи
#lorem(100)

== Хід роботи
#v(-spacing)
=== Підготовка
#lorem(150)

=== Виконання дослідження
#lorem(300)

=== Підрахунок результатів
#lorem(250)

== Висновки
#lorem(100)

== Контрольні запитання
#lorem(100):
- #lorem(20);
- #lorem(30);
- #lorem(15);
- #lorem(25);
- #lorem(42);
- #lorem(27).
