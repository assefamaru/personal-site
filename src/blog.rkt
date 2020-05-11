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
               #:title "Post"
               #:theme "light"
               #:params (list name)
               fake-post))

(define (gen-divs maxp)
  `(div ,@(map
           (lambda (x)
             (define y (number->string x))
             `(div (a ((href ,(string-append "/blog/" y)))
                      (string-append "Blog - " y))))
           (build-list maxp values))))

(define (fake-blog)
  `(div
    (p "Blog page!")
    (div
     (a ((href "/"))
        "see home pages!"))
    ,(gen-divs 50)))

(define (fake-post name)
  `(div
    (p ,(string-append "Hello, " (car name)))
    (a ((href "/blog"))
       "Go back to blog page!")))