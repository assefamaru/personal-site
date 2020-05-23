#lang racket/base

(require web-server/servlet-env
         "routes.rkt")

;; If port is set by environment,
;; use that value. Otherwise, use
;; port=3000 as default.
(define port
  (if (getenv "PORT")
      (string->number (getenv "PORT"))
      3000))

;; start : request? -> response
;; Consumes a request and produces a page
;; that displays all of the web content.
(define (start request)
  (route request))

;; Set up and start server instance.
(serve/servlet start
               ; use serve/servlet in a startup script
               ; instead of opening a browser
               ; - set to #t in production
               #:command-line? #t
               ; set to #f and accept connections to
               ; all listening machines' addresses
               #:listen-ip #f
               ; set the port
               #:port port
               ; customize base URL
               #:servlet-path "/"
               ; servlet is run as a stateless module
               #:stateless? #t
               ; capture all top level requests
               #:servlet-regexp #rx"")