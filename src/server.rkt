#lang racket/base

(require "db.rkt"
         "routes.rkt"
         web-server/servlet-env)

;; start : request -> response
(define (start request)
  (route request))

;; Set up and start server instance.
(serve/servlet start
               ; use serve/servlet in a startup script
               ; instead of opening a browser
               ; - set to #t on deploy
               #:command-line? #t
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
               #:extra-files-paths '()
               ; capture all top level requests
               #:servlet-regexp #rx"")