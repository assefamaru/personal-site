#lang racket/base

(require "themes.rkt"
         web-server/servlet)

(provide render-page)

(define (render-page
         request
         #:title  [title "Alexander Maru"]
         #:theme  [theme "dark"]
         #:params [params '()]
         .
         components)
  (response/xexpr
   `(html ,(meta title theme)
          (body
           (div ((class "vline vline1")))
           (div ((class "vline vline2")))
           (div ((class "vline vline3")))
           (div ((class "vline vline4")))
           (div ((class "vline vline5")))
           ,header
           ,sidebar
           ,sidebar-right
           ,@(map
              (lambda (c)
                (if (null? params)
                    (c)
                    (c params)))
              components)
           ,footer))))

(define (meta title theme)
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

(define header
  `(header ((class "header"))
           (ul ((class "hdr-ul"))
               (li ((class "hdr-li"))
                   (a ((href "/")
                       (class "hdr-a hdr-a1"))
                      "Home")))
           (ul ((class "hdr-ul"))
               (li ((class "hdr-li"))
                   (a ((href "#")
                       (class "hdr-a hdr-a2"))
                      "Blog"))
               (li ((class "hdr-li"))
                   (a ((href "#")
                       (class "hdr-a hdr-a3"))
                      "Projects"))
               (li ((class "hdr-li"))
                   (a ((href "#")
                       (class "hdr-a hdr-a4"))
                      "About"))
               (li ((class "hdr-li"))
                   (a ((href "#")
                       (class "hdr-a hdr-a5"))
                      "More")))))

(define sidebar
  `(div ((class "sidebar"))
        (div ((class "sidebar-content"))
             (a ((href "https://github.com/assefamaru")
                 (target "_blank"))
                (i ((class "fa fa-github")
                    (area-hidden "true"))))
             (a ((href "https://www.linkedin.com/in/alexandermaru")
                 (target "_blank"))
                (i ((class "fa fa-linkedin")
                    (area-hidden "true"))))
             (a ((href "https://twitter.com/assefamaru")
                 (target "_blank"))
                (i ((class "fa fa-twitter")
                    (area-hidden "true"))))
             (a ((href "https://stackoverflow.com/users/4739247/assefamaru")
                 (target "_blank"))
                (i ((class "fa fa-stack-overflow")
                    (area-hidden "true"))))
             (a ((href "https://www.instagram.com/assefamaru")
                 (target "_blank"))
                (i ((class "fa fa-instagram")
                    (area-hidden "true")))))))

(define sidebar-right
  `(div ((class "sidebar sidebar-right"))
        (div ((class "sidebar-right-content"))
             (a ((href "/login"))
                (i ((class "fa fa-lock")
                    (area-hidden "true"))))
             (a ((href "#"))
                (i ((class "fa fa-adjust")
                    (area-hidden "true")))))))

(define footer
  `(div ((class "footer"))
        (small
         "Copyright © 2015 — "
         (span ((id "year")))
         ", "
         (a ((href "https://alexandermaru.com"))
            "@assefamaru")
         ".")
        (script "document.getElementById(\"year\").innerHTML = new Date().getFullYear();")))