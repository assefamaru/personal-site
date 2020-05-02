#lang racket

(require "header.rkt"
         web-server/servlet)

(provide/contract (blog-path (request? . -> . response?))
                  (post-path (request? string? . -> . response?)))

(define (blog-path request)
  (response/xexpr
   `(html ,(meta "Alexander Maru")
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

(define (post-path request name)
  (response/xexpr
   `(html ,(meta "Alexander Maru")
          (body
           (p ,(string-append "Hello, " name))
           (a ((href "/blog"))
              "Go back to blog page!")))))