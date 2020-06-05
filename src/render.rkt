#lang racket/base

(require web-server/http/xexpr
         racket/string
         "styles.rkt")

(provide render/page)

;; (render/page request?
;;             [#:title       : (or string? #f)
;;              #:description : (or string? #f)
;;              #:theme       : theme?
;;              #:params      : (or any #f)
;;              #:code        : integer?]
;;              .
;;              (listof xexpr)) -> response?
;; Consumes a request, keyword args, and xexpr components,
;; and produces a page that displays all the components.
;; Acts as a template to produce the full page content.
(define (render/page request
                     #:title [title #f]
                     #:description [description #f]
                     #:theme [theme dark-theme]
                     #:params [params #f]
                     #:code [code 200]
                     .
                     components)
  (response/xexpr
   #:code code
   #:preamble #"<!doctype html>"
   `(html
     (head
      (meta ((charset "utf-8")))
      (meta ((name "viewport")
             (content "width=device-width, initial-scale=1")))
      (title ,(render/title title))
      (meta ((name "author")
             (content "Alexander Maru")))
      (meta ((name "description")
             (content ,(render/description description))))
      (link ((rel "shortcut icon")
             (href "https://assets.alexandermaru.com/favicon.png")))
      (meta ((property "og:title")
             (content ,(render/title title))))
      (meta ((property "og:type")
             (content "website")))
      (meta ((property "og:image")
             (content "https://assets.alexandermaru.com/favicon.png")))
      (meta ((property "og:url")
             (content "https://alexandermaru.com")))
      (meta ((property "og:description")
             (content ,(render/description description))))
      (meta ((name "twitter:card")
             (content "summary_large_image")))
      (meta ((name "twitter:site")
             (content "@assefamaru")))
      (meta ((name "twitter:creator")
             (content "@assefamaru")))
      (link ((rel "stylesheet")
             (href "https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,400i,600,700")))
      (style ,theme)
      (style ,non-theme)
      (script ((src "https://use.fontawesome.com/78853d9834.js")))
      (script ((async "")
               (src "https://www.googletagmanager.com/gtag/js?id=UA-106749390-2")))
      (script ,(string-normalize-spaces
                "window.dataLayer = window.dataLayer || [];
                 function gtag(){dataLayer.push(arguments);}
                 gtag('js', new Date());
                 gtag('config', 'UA-106749390-2');")))
     (body
      (header
       (a ((href "/")
           (class "hdr-a1"))
          "Home")
        (a ((href "/blog")
            (class "hdr-a2"))
           "Blog")
        (a ((href "#")
            (class "hdr-a3"))
           "Projects")
        (a ((href "#")
            (class "hdr-a4"))
           "More"))
      (div ((class "sidebar sidebar-left"))
           (div ((class "sidebar-left-content"))
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
                       (area-hidden "true"))))))
      (div ((class "sidebar sidebar-right"))
           (div ((class "sidebar-right-content"))
                (a ((href "#"))
                   (i ((class "fa fa-chain-broken")
                       (area-hidden "true"))))
                (a ((href "#"))
                   (i ((class "fa fa-pie-chart")
                       (area-hidden "true"))))))
      (div ((class "content-wrapper"))
           ,@(map
              (lambda (x)
                (if (not params)
                    (x)
                    (x params)))
              components))
      (div ((class "spacer-y")))
      (footer
       (small
        "Copyright © 2015 — "
        (span ((id "year")))
        ", "
        (a ((href "https://alexandermaru.com"))
           "@assefamaru")
        ".")
       (script "document.getElementById(\"year\").innerHTML = new Date().getFullYear();"))))))

;; render/title : (or boolean? string?) -> string?
;; Dynamically generate page title.
(define (render/title content)
  (cond
    ((not content) "Alexander Maru")
    (else
     (string-append content " | Alexander Maru"))))

;; render/description : (or boolean? string?) -> string?
;; Dynamically generate page description.
(define (render/description content)
  (if (not content)
      "Student, programmer, aspiring mathematician."
      content))