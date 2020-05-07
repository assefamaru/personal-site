#lang racket/base

(require "themes.rkt")

(provide meta vertical-lines)

(define (meta #:title [title "Alexander Maru"] #:theme [theme "dark"])
  `(head
    (meta ((charset "utf-8")))
    (meta ((name "viewport")
           (content "width=device-width, initial-scale=1")))
    (title ,(if (equal? title "Alexander Maru")
                title
                (string-append title " | Alexander Maru")))
    (meta ((name "author")
           (content "Alexander Maru")))
    (meta ((name "description")
           (content "Student, programmer, aspiring mathematician.")))
    (link ((rel "shortcut icon")
           (href "https://s3.ca-central-1.amazonaws.com/assets.alexandermaru.com/favicon.png")))
    (meta ((property "og:title")
           (content "Alexander Maru")))
    (meta ((property "og:type")
           (content "website")))
    (meta ((property "og:image")
           (content "https://s3.ca-central-1.amazonaws.com/assets.alexandermaru.com/favicon.png")))
    (meta ((property "og:url")
           (content "https://alexandermaru.com")))
    (meta ((property "og:description")
           (content "Student, programmer, aspiring mathematician.")))
    (meta ((name "twitter:card")
           (content "summary_large_image")))
    (meta ((name "twitter:site")
           (content "@assefamaru")))
    (meta ((name "twitter:creator")
           (content "@assefamaru")))
    (link ((rel "stylesheet")
           (href "https://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,400i,600,700,900")))
    (style ,(if (equal? theme "dark")
                dark-theme
                light-theme))
    (style ,non-theme)
    (script ((src "https://use.fontawesome.com/78853d9834.js")))
    (script ((async "")
             (src "https://www.googletagmanager.com/gtag/js?id=UA-106749390-2")))
    (script "window.dataLayer = window.dataLayer || [];
             function gtag(){dataLayer.push(arguments);}
             gtag('js', new Date());
             gtag('config', 'UA-106749390-2');")))

(define (vertical-lines)
  `(span
    (div ((class "vline vline1")))
    (div ((class "vline vline2")))
    (div ((class "vline vline3")))
    (div ((class "vline vline4")))
    (div ((class "vline vline5")))))