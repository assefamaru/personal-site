#lang racket

(require "header.rkt"
         "home.rkt"
         "blog.rkt"
         web-server/servlet
         web-server/servlet-env)

; start : request -> response
(define (start request)
  (render-home-page request))

; render-home-page : request -> response
(define (render-home-page request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html ,(meta "Alexander Maru")
            (body
             (p "Hello, world!")
             (a ((href ,(embed/url render-blog-page)))
                "see blog page!")))))
  (send/suspend/dispatch response-generator))

; render-blog-page : request -> response
(define (render-blog-page request)
  (define (response-generator embed/url)
    (response/xexpr
     `(html ,(meta "Alexander Maru")
            (body
             (p "Blog page!")
             (a ((href ,(embed/url render-home-page)))
                "see home page!")))))
  (send/suspend/dispatch response-generator))

; If port is set by environment,
; use that value. Otherwise, use
; port=3000 as default.
(define port
  (if (getenv "PORT")
      (string->number (getenv "PORT"))
      3000))

; Set up and start server instance.
(serve/servlet start
               ; use serve/servlet in a startup script
               ; instead of opening a browser
               ; - set to #t on deploy
               #:command-line? #f
               ; set to #f and accept connections to
               ; all listening machine's addresses
               #:listen-ip #f
               ; set the port
               #:port port
               ; customize base URL
               #:servlet-path "/"
               ; servlet is run as a stateless module
               #:stateless? #t
               ; serve additional files aside from the
               ; ones served by #:server-root-path "htdocs"
               #:extra-files-paths
               (list (build-path "./static")))