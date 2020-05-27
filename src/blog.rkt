#lang racket/base

(require "render.rkt"
         "models.rkt"
         "db.rkt")

(provide blog-path
         list-posts
         review-post)

;; Handler for the /blog path.
(define (blog-path request)
  (define posts (db-select-partial-posts db-conn))
  (render-page request
               #:title "Blog"
               #:theme "light"
               (lambda ()
                 `(p "Blog page"))))

;; Handler for the /blog/{category} path.
(define (list-posts request category)
  (define posts (db-select-category-posts db-conn category))
  void)

;; Handler for the /blog/{category}/{id}/{title} path.
(define (review-post request category id title)
  (define post (db-select-post db-conn id title category))
  void)