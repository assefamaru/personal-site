#lang racket

(require "db.rkt"
         "meta.rkt"
         "header.rkt"
         "sidebar.rkt"
         "footer.rkt"
         web-server/servlet)

(provide/contract (list-posts (request? . -> . response?))
                  (review-post (request? string? . -> . response?)))

(define (list-posts request)
  (response/xexpr
   `(html ,(meta #:title "Blog")
          (body
           ,(vertical-lines)
           ,(menu)
           ,(sidebar)
           ,(sidebar-right)
           ,(footer)
           ; Enter page content here =====
           (p "Blog page!")
           (a ((href "/"))
              "see home page!")
           (a ((href "/blog/1"))
              "First blog")
           (a ((href "/blog/2"))
              "Second blog")
           (a ((href "/blog/3"))
              "Third blog")
           ; End of page content =========
           ))))

(define (review-post request name)
  (response/xexpr
   `(html ,(meta #:theme "light")
          (body
           ,(vertical-lines)
           ,(menu)
           ,(sidebar)
           ,(sidebar-right)
           ,(footer)
           ; Enter page content here =====
           (p ,(string-append "Hello, " name))
           (a ((href "/blog"))
              "Go back to blog page!")
           ; End of page content =========
           ))))