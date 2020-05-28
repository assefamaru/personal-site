#lang racket/base

(require web-server/servlet
         web-server/servlet-env
         "home.rkt"
         "blog.rkt"
         "forms.rkt"
         "private.rkt"
         "errors.rkt")

;; start : request? -> response
;; Consumes a request and produces a page
;; that displays all of the web content.
(define (start request)
  (dispatch request))

;; URL dispatching rules.
(define-values (dispatch request)
  (dispatch-rules
   [("") home-path]
   [("blog") blog-path]
   [("blog" (string-arg)) list-posts]
   [("blog" (string-arg) (integer-arg) (string-arg)) review-post]
   [("login") login-path]
   [("r") private-path]
   [("r" (string-arg)) private-path]
   [("r" (string-arg) (string-arg)) private-path]
   [("r" (string-arg) (integer-arg)) private-path]
   [else error/404]))

;; Use PORT environment variable.
;; Default: 3000.
(define port
  (if (getenv "PORT")
      (string->number (getenv "PORT"))
      3000))

;; Set up and start server instance.
(serve/servlet start
               ; use serve/servlet in a startup script
               ; instead of opening a browser
               ; - set to #t in production
               #:command-line? #f
               ; set to #f and accept connections to
               ; all listening machines' addresses
               #:listen-ip #f
               ; set the port
               #:port port
               ; customize base URL
               #:servlet-path "/"
               ; servlet is stateful (for now)
               #:stateless? #f
               ; capture all top level requests
               #:servlet-regexp #rx"")