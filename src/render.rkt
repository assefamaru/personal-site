#lang racket/base

(require web-server/servlet
         "themes.rkt"
         "utils.rkt")

(provide render-page)

;; (render-page request?
;;             [#:title   : (or string? #f)
;;              #:desc    : (or string? #f)
;;              #:theme   : (or string? #f)
;;              #:params  : (or any #f)
;;              #:error   : boolean?
;;              #:code    : integer?
;;              #:message : string?]
;;              .
;;              (listof xexpr)) -> response?
;; Consumes a request, keyword args, and xexpr components,
;; and produces a page that displays all the components.
;; Acts as a template to produce the full content of every
;; page served by site.
(define (render-page request
                     #:title   [title   #f]
                     #:desc    [desc    #f]
                     #:theme   [theme   #f]
                     #:params  [params  #f]
                     #:error   [error   #f]
                     #:code    [code    200]
                     #:message [message "OK"]
                     .
                     components)
  (response/xexpr
   #:code code
   #:preamble #"<!DOCTYPE html>"
   `(html ,(meta title desc theme error code message)
          (body
           (div ((class "vline vline1")))
           (div ((class "vline vline2")))
           (div ((class "vline vline3")))
           (div ((class "vline vline4")))
           (div ((class "vline vline5")))
           ,header
           ,sidebar-left
           ,sidebar-right
           ,@(map
              (lambda (c)
                (if (not params)
                    (c)
                    (c params)))
              components)
           (div ((class "spacer")))
           ,footer))))

;; (meta (or string? #f)
;;       (or string? #f)
;;       (or string? #f)
;;       boolean?
;;       integer?
;;       string?) -> xexpr
;; Produces the head section of each web page.
(define (meta title desc theme error code message)
  `(head
    (meta ((charset "utf-8")))
    (meta ((name "viewport")
           (content "width=device-width, initial-scale=1")))
    (title ,(make-title title error code message))
    (meta ((name "author")
           (content "Alexander Maru")))
    (meta ((name "description")
           (content ,(if (not desc)
                         "Student, programmer, aspiring mathematician."
                         desc))))
    (link ((rel "shortcut icon")
           (href "https://assets.alexandermaru.com/favicon.png")))
    (meta ((property "og:title")
           (content ,(make-title title error code message))))
    (meta ((property "og:type")
           (content "website")))
    (meta ((property "og:image")
           (content "https://assets.alexandermaru.com/favicon.png")))
    (meta ((property "og:url")
           (content "https://alexandermaru.com")))
    (meta ((property "og:description")
           (content ,(if (not desc)
                         "Student, programmer, aspiring mathematician."
                         desc))))
    (meta ((name "twitter:card")
           (content "summary_large_image")))
    (meta ((name "twitter:site")
           (content "@assefamaru")))
    (meta ((name "twitter:creator")
           (content "@assefamaru")))
    (link ((rel "stylesheet")
           (href "https://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,400i,600,700,900")))
    (style ,(if (not theme)
                dark-theme
                light-theme))
    (style ,non-theme)
    (script ((src "https://use.fontawesome.com/78853d9834.js")))
    (script ((async "")
             (src "https://www.googletagmanager.com/gtag/js?id=UA-106749390-2")))
    (script ,(string-clean "window.dataLayer = window.dataLayer || [];
                            function gtag(){dataLayer.push(arguments);}
                            gtag('js', new Date());
                            gtag('config', 'UA-106749390-2');"))))

;; (make-title (or string? #f) boolean? integer? string?) -> string?
;; Produces a dynamic title for each web page.
(define (make-title title error code message)
  (cond
    (error (string-append
            "Error " (number->string code) " (" message ")"))
    ((not title) "Alexander Maru")
    (else
     (string-append title " | Alexander Maru"))))

;; header: xexpr
;; The site header.
(define header
  `(header ((class "header"))
           (ul ((class "hdr-ul"))
               (li ((class "hdr-li"))
                   (a ((href "/")
                       (class "hdr-a hdr-a1"))
                      "Home")))
           (ul ((class "hdr-ul"))
               (li ((class "hdr-li"))
                   (a ((href "/blog")
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

;; sidebar-left: xexpr
;; The site sidebar (left).
(define sidebar-left
  `(div ((class "sidebar sidebar-left"))
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
                    (area-hidden "true")))))))

;; sidebar-right: xexpr
;; The site sidebar (right).
(define sidebar-right
  `(div ((class "sidebar sidebar-right"))
        (div ((class "sidebar-right-content"))
             (a ((href "#")
                 (title "Switch theme"))
                (i ((class "fa fa-adjust")
                    (area-hidden "true"))))
             (a ((href "/login"))
                (i ((class "fa fa-lock")
                    (area-hidden "true")))))))

;; footer: xexpr
;; The site footer.
(define footer
  `(footer ((class "footer"))
           (small
            "Copyright © 2015 — "
            (span ((id "year")))
            ", "
            (a ((href "https://alexandermaru.com"))
               "@assefamaru")
            ".")
           (script "document.getElementById(\"year\").innerHTML = new Date().getFullYear();")))