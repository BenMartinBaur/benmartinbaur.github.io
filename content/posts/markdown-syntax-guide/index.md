---
title: "Markdown Syntax Guide"
description: "A comprehensive reference for Markdown syntax and formatting options available in Hugo."
date: 2026-02-12
image: featured.jpg
tags:
  - Markdown
  - Reference
  - Hugo
categories:
  - Documentation
---

This article provides a comprehensive reference for Markdown syntax that can be used in Hugo content files. Use this as a quick reference when writing blog posts.

<!--more-->

## Headings

The following HTML `<h1>`—`<h6>` elements represent six levels of section headings. `<h1>` is the highest section level while `<h6>` is the lowest.

# H1
## H2
### H3
#### H4
##### H5
###### H6

## Paragraph

Regular paragraphs are simply one or more consecutive lines of text, separated by one or more blank lines. Normal paragraphs should not be indented with spaces or tabs.

This is a second paragraph demonstrating how text flows naturally. You can write as much as you need, and the text will wrap automatically.

## Emphasis

Use asterisks or underscores for emphasis:

- *This text is italicized*
- _This is also italicized_
- **This text is bold**
- __This is also bold__
- ***This text is bold and italic***
- ~~This text is strikethrough~~

## Blockquotes

The blockquote element represents content that is quoted from another source.

### Simple Blockquote

> This is a blockquote. It can span multiple lines and is commonly used for quoting external sources or highlighting important information.

### Nested Blockquote

> This is the outer quote.
>
> > This is a nested quote inside the outer quote.
>
> Back to the outer quote.

### Blockquote with Attribution

> The only way to do great work is to love what you do.
>
> — Steve Jobs

## Lists

### Ordered List

1. First item
2. Second item
3. Third item
4. Fourth item

### Unordered List

- List item
- Another item
- And another item

### Nested List

- Fruits
  - Apple
  - Orange
  - Banana
- Vegetables
  - Carrot
  - Broccoli

### Task List

- [x] Completed task
- [ ] Incomplete task
- [ ] Another task to do

## Code

### Inline Code

Use backticks for `inline code` within a sentence.

### Code Block with Syntax Highlighting

```javascript
function greet(name) {
  console.log(`Hello, ${name}!`);
  return true;
}

greet("World");
```

```python
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

print(fibonacci(10))
```

```bash
# Clone a repository
git clone https://github.com/user/repo.git

# Navigate to directory
cd repo

# Install dependencies
npm install
```

### Diff Code Block

```diff
- old line that was removed
+ new line that was added
  unchanged line
- another removed line
+ another added line
```

## Tables

Tables are created using pipes and hyphens:

| Name    | Age | Occupation     |
|---------|-----|----------------|
| Alice   | 28  | Developer      |
| Bob     | 32  | Designer       |
| Charlie | 25  | Product Manager|

### Aligned Columns

| Left Aligned | Center Aligned | Right Aligned |
|:-------------|:--------------:|--------------:|
| Left         | Center         | Right         |
| Text         | Text           | Text          |

## Links

### Basic Links

- [External Link](https://example.com)
- [Link with Title](https://example.com "Example Website")
- [Relative Link](/about)

### Reference Links

This is a [reference link][ref1] and here's [another one][ref2].

[ref1]: https://example.com "Reference 1"
[ref2]: https://example.org "Reference 2"

## Images

Images can be added using the following syntax:

```markdown
![Alt text](/path/to/image.jpg)
![Alt text](/path/to/image.jpg "Optional Title")
```

For local images, place them in the `static/images/` folder and reference them with `/images/filename.jpg`.

## Horizontal Rules

Create horizontal rules with three or more hyphens, asterisks, or underscores:

---

***

___

## Special Elements

### Abbreviations

The HTML specification is maintained by the W3C.

*[HTML]: Hyper Text Markup Language
*[W3C]: World Wide Web Consortium

### Subscript and Superscript

- H~2~O (water)
- X^2^ (x squared)

### Keyboard Keys

Press <kbd>Ctrl</kbd> + <kbd>C</kbd> to copy and <kbd>Ctrl</kbd> + <kbd>V</kbd> to paste.

### Highlighted Text

Use the <mark>mark element</mark> to highlight important text.

### Footnotes

Here's a sentence with a footnote.[^1]

[^1]: This is the footnote content.

## Math (if enabled)

Inline math: $E = mc^2$

Block math:

$$
\frac{n!}{k!(n-k)!} = \binom{n}{k}
$$

## Escaping Characters

Use backslash to escape special characters:

\*This text is surrounded by asterisks\*

\# This is not a heading

## Comments

<!-- This is a comment that won't appear in the rendered output -->

Comments are useful for notes to yourself or other editors.

---

This guide covers the most common Markdown syntax. For theme-specific features, check the [Hugo Theme Stack documentation](https://stack.jimmycai.com/).
