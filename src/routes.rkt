#lang racket

(require "theme.rkt"
         "home.rkt"
         "blog.rkt"
         "error.rkt"
         web-server/servlet
         web-server/dispatch)

(provide route)

;; URL dispatching rules
;; for site routes.
(define-values (route a-url)
  (dispatch-rules
   [("") root-path]
   [("blog") blog-path]
   [("blog" (string-arg)) post-path]
   [("style.css" (string-arg)) style-path]
   [else error-path]))