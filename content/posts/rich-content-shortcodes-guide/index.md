---
title: "Rich Content & Shortcodes Guide"
description: "A reference for Hugo shortcodes and rich content features available in the Stack theme."
date: 2026-02-12
image: featured.jpg
tags:
  - Shortcodes
  - Reference
  - Hugo
categories:
  - Documentation
---

This guide covers the various shortcodes and rich content features available in the Hugo Stack theme. Shortcodes extend Markdown with powerful embedding and formatting capabilities.

<!--more-->

## Quote Shortcode

The `quote` shortcode displays formatted quotes with author attribution.

{{< quote author="Albert Einstein" source="The World As I See It" url="https://en.wikipedia.org/wiki/Albert_Einstein" >}}
Imagination is more important than knowledge. Knowledge is limited. Imagination encircles the world.
{{< /quote >}}

### Usage

```
{{</* quote author="Author Name" source="Source Title" url="https://example.com" */>}}
Your quote content here.
{{</* /quote */>}}
```

## YouTube Videos

Embed YouTube videos using Hugo's built-in shortcode.

{{< youtube dQw4w9WgXcQ >}}

### Usage

```
{{</* youtube VIDEO_ID */>}}
```

## Video Shortcode

Embed self-hosted or remote video files.

### Usage

```
{{</* video src="https://example.com/video.mp4" */>}}
```

You can also use multiple sources for browser compatibility:

```
{{</* video src="video.webm" autoplay="true" loop="true" muted="true" */>}}
```

## Mermaid Diagrams

Stack theme supports Mermaid diagrams out of the box. Simply use a code block with the `mermaid` language.

### Flowchart

```mermaid
graph TD;
    A[Start] --> B{Decision};
    B -->|Yes| C[Do something];
    B -->|No| D[Do something else];
    C --> E[End];
    D --> E;
```

### Sequence Diagram

```mermaid
sequenceDiagram
    participant User
    participant Server
    participant Database
    
    User->>Server: Request data
    Server->>Database: Query
    Database-->>Server: Return results
    Server-->>User: Send response
```

### Gantt Chart

```mermaid
gantt
    title Project Timeline
    dateFormat  YYYY-MM-DD
    section Planning
    Research           :a1, 2026-01-01, 30d
    Design             :after a1, 20d
    section Development
    Implementation     :2026-02-20, 45d
    Testing            :2026-04-01, 15d
```

### Class Diagram

```mermaid
classDiagram
    Animal <|-- Duck
    Animal <|-- Fish
    Animal : +int age
    Animal : +String gender
    Animal: +isMammal()
    Animal: +mate()
    class Duck{
        +String beakColor
        +swim()
        +quack()
    }
    class Fish{
        -int sizeInFeet
        -canEat()
    }
```

## GitLab Snippets

Embed code snippets from GitLab.

### Usage

```
{{</* gitlab SNIPPET_ID */>}}
```

## Gist Embedding

Embed GitHub Gists using Hugo's built-in shortcode.

### Usage

```
{{</* gist USERNAME GIST_ID */>}}
```

## Twitter/X Embedding

Embed tweets (note: may require additional configuration).

### Usage

```
{{</* tweet user="username" id="TWEET_ID" */>}}
```

## Figure Shortcode

Enhanced image display with captions and links.

```
{{</* figure src="/images/photo.jpg" caption="A sample figure with caption" */>}}
```

### Usage

```
{{</* figure src="/images/photo.jpg" 
    caption="Image caption here" 
    alt="Alt text"
    link="https://example.com" */>}}
```

## Highlight Shortcode

Syntax highlighting with line numbers and highlighting specific lines.

{{< highlight go "linenos=table,hl_lines=3 5-7" >}}
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
    fmt.Println("This line is highlighted")
}
{{< /highlight >}}

### Usage

```
{{</* highlight language "options" */>}}
Your code here
{{</* /highlight */>}}
```

Options include:
- `linenos=table` - line numbers in a table
- `linenostart=10` - start line numbers at 10
- `hl_lines=3 5-7` - highlight specific lines

## Instagram Embedding

Embed Instagram posts.

### Usage

```
{{</* instagram POST_ID */>}}
```

## Vimeo Videos

Embed Vimeo videos.

### Usage

```
{{</* vimeo VIDEO_ID */>}}
```

## Param Shortcode

Display site parameters in your content.

The site title is: {{< param title >}}

## Ref and Relref

Create links to other pages in your site.

### Usage

```
[Link to another post]({{</* ref "posts/other-post.md" */>}})
[Relative link]({{</* relref "about.md" */>}})
```

---

## Tips for Using Shortcodes

1. **Escape shortcodes** in documentation by using `/*` and `*/` inside the delimiters
2. **Combine shortcodes** with Markdown for richer content
3. **Check the theme docs** for additional shortcodes specific to Stack theme
4. **Test locally** before publishing to ensure embeds display correctly

For more information, see the [Hugo Shortcodes Documentation](https://gohugo.io/content-management/shortcodes/) and [Stack Theme Documentation](https://stack.jimmycai.com/).
