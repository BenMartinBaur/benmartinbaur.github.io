---
title: "HUGO Site Configuration"
date: 2025-03-16T19:37:45+01:00
description: ""
draft: true
author: ""
cover: ""
tags: [""]
theme: "light"
---

Site COnfiguation

defaultContentLanguage = "en" # current only supported 'en' and 'zh-hans', see the 'i18n' folder
[params]
  defaultCover = 'https://example.com/cover.jpg' # default cover image for post not setting cover
  email = 'floyd.li@outlook.com' # the email address display in the footer
  [params.algolia] # Algolia search configuration
    enabled = true # enable Algolia search
    appId = 'YOUR_KEY' # appid for Algolia search
    appKey = 'YOUR_APP_KEY' # appkey for Algolia search
    searchIndex = 'YOUR_INDEX' # index for Algolia search
  [[params.css]] # custom css stylesheet, you can add one or more, url is relative in 'static' folder
    url = 'css1.css'
  [[params.css]]
    url = 'css2.css'
  [[params.js]] # custom javascript, you can add one or more, url is relative in 'static' folder
    url = 'js1.js'
  [[params.js]]
    url = 'js2.js'
  [[params.socialMedia]] # custom social links display in the footer, you can add one or more
    name = 'Github'
    url = 'https://github.com/floyd-li'
  [[params.socialMedia]]
    name = 'Twitter'
    url = 'https://twitter.com/some-one'
  [[params.blogroll]] # blogroll links display in the footer, you can add one or more
    name = 'Apple'
    url = 'https://Apple.com/'
  [[params.blogroll]]
    name = 'Google'
    url = 'https://Google.com/'


hugo new posts/ACD.md



```
---
    title: 'Some Article'
    date: '2022-10-27T13:06:38+08:00'
    draft: true
    description: 'some description of the article'
    author: 'author of this article'
    cover: 'https://example.com/cover.jpg' // if not set cover, it will use the 'defaultCover' in site configuration
    tags: ["tag1", "tag2", "tag3"]
    theme: "dark" // you can set 'light' or 'dark' here
    ---
```

