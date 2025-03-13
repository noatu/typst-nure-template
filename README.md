# Typst Template for NURE Works

## General Info

This project contains two template functions and some utilities for writing NURE works. All functions include documentation comments inside them, so you can explore all possibilities using LSP.

### Templates

#### `pz-lb-template` - For Laboratory and Practical Works
This template:
- Sets up document styles;
- Formats the title page according to NURE/DSTU guidelines.

#### `cw-template` - For Course Works
This template:
- Sets up document styles;
- Formats the title, task, calendar plan, and abstract pages;
- Typesets the bibliography, outline, and appendices according to standard requirements.

### Utilities
- `nheading` - For unnumbered headings, such as "Introduction" and "Conclusion".
- `hfill` - Fills horizontal space with a filled box instead of just empty space; useful for creating underlines.
- `uline` - Creates underlined fields that need to be filled, such as the name field on the task list.
- `bold` - Inserts bold text inside functional environments.
- `img` - Inserts images with a caption, automatically deriving the label from the image file name.

## Usage

### As a local typst package
1. Clone this repository into ~/.local/share/typst/packages/:
```bash
git clone -b 0.1.0 https://gitea.linerds.us/pencelheimer/typst_nure_template.git ~/.local/share/typst/packages/local/nure/0.1.0
```
2. Init your project with Typst:
```bash
typst init @local/nure:0.1.0 project-name
```

### As a standalone file
Copy `lib.typ` to your project's root directory.

### In your project
```typst
// Import the template either from a local package...
#import "@local/nure:0.1.0": *
// ...or by importing a lib.typ directly
// #import "/lib.typ": *

// Setup the document
#show: pz-lb-template.with(
    title: "Some title",
    // etc: "and so on",
    // ...
)
// this template automatically inserts a `=title`

// Write your content...
#v(-spacing) // remove spacing between headings
== Purpose
Some text

// ...or include your modules
// NOTE: you have to import a package or a lib.typ in each module.
#include "src/intro.typ"
#include "src/chapter1.typ"
#include "src/chapter2.typ"
```

### Notes:
1. Use `#v(-spacing)` to remove vertical spacing between titles (this cannot be automatically handled by the template). Variable `spacing` used here is imported from the template.

### Example Project Structure
```
project/
├── main.typ -- for importing, configuration and boilerplate
├── src/
│   ├── intro.typ
│   ├── chapter1.typ
│   ├── chapter2.typ
│   └── ...
├── figures/
│   ├── chapter1/
│   │   ├── figure1.png
│   │   ├── figure2.png
│   │   ├── figure3.png
│   │   └── ...
│   ├── chapter2/
│   │   ├── figure1.png
│   │   ├── figure2.png
│   │   ├── figure3.png
│   │   └── ...
│   └── ...
└── ...
```
