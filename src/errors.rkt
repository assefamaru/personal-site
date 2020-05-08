#lang racket/base

(require "render.rkt"
         web-server/servlet)

(provide error-not-found)

(define (error-not-found request)
  (render-page request #:error #t #:code 404 not-found))

(define (not-found)
  `(div ((class "error"))
        (h1 "404: Page Not Found")
        (p
         "Go back to "
         (a ((href "/"))
            "home page")
         ".")))