#lang racket

(require "meta.rkt"
         web-server/servlet)

(provide/contract (list-posts (request? . -> . response?))
                  (review-post (request? string? . -> . response?)))

(define (list-posts request)
  (response/xexpr
   `(html ,(meta #:theme "light")
          (body
           (p "Blog page!")
           (a ((href "/"))
              "see home page!")
           (a ((href "/blog/1"))
              "First blog")
           (a ((href "/blog/2"))
              "Second blog")
           (a ((href "/blog/3"))
              "Third blog")))))

(define (review-post request name)
  (response/xexpr
   `(html ,(meta #:theme "light")
          (body
           (p ,(string-append "Hello, " name))
           (a ((href "/blog"))
              "Go back to blog page!")))))