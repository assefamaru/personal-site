#lang racket/base

(require "render.rkt")

(provide blog-path
         list-posts
         review-post)

;; Handler for the /blog path.
(define (blog-path request)
  (render-page request
               (lambda ()
                 `(p "Blog page"))))

;; Handler for the /blog/{category} path.
(define (list-posts request category)
  void)

;; Handler for the /blog/{category}/{id}/{title} path.
(define (review-post request category id title)
  void)