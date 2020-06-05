#lang racket/base

(require "render.rkt")

(provide blog-path
         list-posts
         review-post)

(define (blog-path request)
  (render/page request `(div)))

(define (list-posts request)
  (render/page request `(div)))

(define (review-post request)
  (render/page request `(div)))