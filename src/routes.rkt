#lang racket

(require "home.rkt"
         "blog.rkt"
         web-server/dispatch)

(provide route)

;; URL dispatching rules
;; for site routes.
(define-values (route a-url)
  (dispatch-rules
   [("") render-home]
   [("blog") render-blog]
   [("blog" (string-arg)) view-post]
   [else render-home]))