#lang racket

(require "themes.rkt"
         web-server/servlet)

(provide meta)

;; head : string -> response
(define (meta #:title [title "Alexander Maru"] #:theme [theme "dark"])
  `(head
    (meta ((charset "utf-8")))
    (meta ((name "viewport")
           (content "width=device-width, initial-scale=1")))
    (title ,title)
    (meta ((name "author")
           (content "Alexander Maru")))
    (meta ((name "description")
           (content "Student, programmer, aspiring mathematician.")))
    (link ((rel "stylesheet")
           (href "https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700,900")))
    (style ,(if (equal? theme "dark")
                dark-theme
                light-theme))
    (style ,render-styles)
    (script ((type "text/javascript")
             (src "https://use.fontawesome.com/78853d9834.js")))
    (script ((async "")
             (src "https://www.googletagmanager.com/gtag/js?id=UA-106749390-2")))
    (script "window.dataLayer = window.dataLayer || []; function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date()); gtag('config', 'UA-106749390-2');")))