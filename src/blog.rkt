#lang racket/base

(require racket/vector
         web-server/servlet)

(provide blog-path
         list-posts
         review-post)

;; Handler for the /blog path.
(define (blog-path request)
  void)

;; Handler for the /blog/{category} path.
(define (list-posts request category)
  void)

;; Handler for the /blog/{category}/{id}/{title} path.
(define (review-post request category id title)
  void)

;; ===============================================

(define (blog/xexpr request)
  void)