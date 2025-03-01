# Typst Template for NURE Works

## General Info

This project contains two template functions and some utilities for writing NURE works. All functions include documentation comments inside them, so you can explore all possibilities using LSP.

### Templates

#### `pz-lb-template` - For Laboratory and Practical Works
This template:
- Sets up document styles;
- Formats the title page according to NURE guidelines.

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
git clone https://gitea.linerds.us/pencelheimer/typst_nure_template.git ~/.local/share/typst/packages/local/nure/0.0.0
```
2. Init your project with Typst:
```bash
typst init @local/nure:0.0.0 project-name
```

### As a file in your project
Include lib.typ in your project and utilize the provided functions:

```typst
// Import the template
#import "lib.typ": *

// Setup the document
#show: lab-pz-template.with(
    title: "Some title",
)
// this template automatically inserts a `=title`

// Write your content
#v(-spacing) // remove spacing between headings
== Purpose
Some text
```

### Notes:
1. Use `#v(-spacing)` to remove vertical spacing between titles (this cannot be automatically handled by the template). Variable `spacing` used here is imported from the template.

### Example Project Structure
```
project-folder/
├── main.typ
├── template.typ
├── images/
│   ├── figure1.png
│   ├── figure2.png
│   ├── ...
├── ...
```
