# Typst Template for NURE Works

> [!INFO]
> Needs more work, but it is functional and ready for use.

## TODO
- Add more information about the template.

## General Info

This project contains two template functions and some utilities for writing NURE works. All functions include documentation comments inside them, so you can explore all possibilities using LSP/IntelliSense.

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

To use the template, include it in your project and utilize the provided functions:

```typst
#import "path/to/template.typ": *     // Import the template
#import "@preview/indenta:0.0.3": fix-indent  // Import indentation fix utility

#show: pz-lb-template.with(
    title: "Some title",
)

#show: fix-indent()

#v(-spacing)
== Purpose
Some text
```

### Notes:
1. You must use the `fix-indent` function from `@preview/indenta` to correct indentation after the title.
2. Use `#v(-spacing)` to remove vertical spacing between titles (this cannot be automatically handled by the template). Notice that the `spacing` variable used here is imported from the template.

### Example Project Structure
```
project-folder/
│-- main.typ
│-- template.typ
│-- images/
│   ├── figure1.png
│   ├── figure2.png
```
This setup ensures that `main.typ` includes and applies the template correctly.
