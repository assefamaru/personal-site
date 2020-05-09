#lang racket/base

(require web-server/dispatch
         "home.rkt"
         "blog.rkt"
         "errors.rkt")

(provide route)

;; URL dispatching rules for site routes.
(define-values (route request)
  (dispatch-rules
   [("") root-path]
   [("blog") list-posts]
   [("blog" (string-arg)) review-post]
   [else error-not-found]))