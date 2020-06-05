#lang racket/base

(require web-server/servlet-env
         web-server/dispatch
         "home.rkt"
         "blog.rkt"
         "errors.rkt")

;; start : request? -> response?
;; Consumes a request and produces a page
;; that displays all of the web content.
(define (start request)
  (dispatch request))

;; URL dispatching rules for site.
(define-values (dispatch request)
  (dispatch-rules
   [("") home-path]
   [("blog") blog-path]
   [("blog" (string-arg)) list-posts]
   [("blog" (string-arg) (integer-arg) (string-arg)) review-post]
   [else error/404]))

;; Retrieve PORT environment variable.
;; If var is missing, default to 3000.
(define port
  (if (getenv "PORT")
      (string->number (getenv "PORT"))
      3000))

;; Set up and start server instance.
(serve/servlet start
               ; Use serve/servlet in a startup script
               ; - #f in development
               ; - #t in production
               #:command-line? #t
               ; Accept connections to all listening
               ; machines' addresses by setting to #f
               #:listen-ip #f
               ; Set the port
               #:port port
               ; Customize base URL
               #:servlet-path "/"
               ; Run servlet as a stateless module
               #:stateless? #t
               ; Capture all top level requests
               #:servlet-regexp #rx"")