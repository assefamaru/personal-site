#lang racket/base

(require "model.rkt"
         "render.rkt"
         web-server/servlet)

(provide list-posts
         review-post)

(define (list-posts request)
  (render-page request
               #:title "Blog"
               fake-blog))

(define (review-post request name)
  (render-page request
               #:title "Blog"
               #:theme "light"
               #:params (list name)
               fake-post))

(define (fake-blog)
  `(div
    (p "Blog page!")
    (a ((href "/"))
       "see home page!")
    (a ((href "/blog/1"))
       "First blog")
    (a ((href "/blog/2"))
       "Second blog")
    (a ((href "/blog/3"))
       "Third blog")))

(define (fake-post name)
  `(div
    (p ,(string-append "Hello, " (car name)))
    (a ((href "/blog"))
       "Go back to blog page!")))