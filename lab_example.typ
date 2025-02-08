#import "template.typ": *
#import "@preview/indenta:0.0.3": fix-indent

#show: lab-pz-template.with(
  doctype: "ЛБ",
  title: "Інформаційна система «Помічник класного керівника». Керування класом",
  subject_shorthand: "БД",
  department_gen: "Програмної інженерії",
  authors: (
    (
      name: "Ситник Є. С.",
      full_name_gen: "Ситника Єгора Сергійовича",
      variant: 13,
      group: "ПЗПІ-23-2",
      gender: "m",
    ),
  ),
  mentor: (
    name: "Черепанова Ю. Ю.",
    gender: "f",
    degree: "Ст. викл. каф. ПІ",
  ),
  worknumber: 1,
)

#show: fix-indent()

#v(-spacing)

== Мета роботи
Супер важлива мета

== Висновки
Супер важливий висновок

== Хід роботи

== Контрольні запитання
Супер важливі контрольні запитання
