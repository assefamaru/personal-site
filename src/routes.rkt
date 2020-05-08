#lang racket/base

(require "home.rkt"
         "blog.rkt"
         "errors.rkt"
         web-server/dispatch)

(provide route)

;; URL dispatching rules
;; for site routes.
(define-values (route a-url)
  (dispatch-rules
   [("") root-path]
   [("blog") list-posts]
   [("blog" (string-arg)) review-post]
   [else error-not-found]))