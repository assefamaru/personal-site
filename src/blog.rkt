#lang racket/base

(require "render.rkt"
         "models.rkt"
         "utils.rkt"
         "db.rkt")

(provide blog-path
         list-posts
         review-post)

;; Handler for the /blog path.
(define (blog-path request)
  (define posts (db-select-partial-posts db-conn))
  (render-page
   request
   #:title "Blog"
   #:theme "dark"
   #:params posts
   (lambda (posts)
     `(div ((class "posts-wrapper"))
           ,@(map (lambda (post)
                    (define id (number->string (vector-ref post 0)))
                    (define title (vector-ref post 1))
                    (define url-title (vector-ref post 2))
                    (define category (vector-ref post 3))
                    (define topics (vector-ref post 4))
                    (define description (vector-ref post 5))
                    (define created-at (timestamp->string (vector-ref post 6)))
                    `(a ((href ,(string-append "/blog/" category "/" id "/" url-title))
                         (class "post-item"))
                        (div (h3 ,title)
                             (small ,created-at)
                             (small " • " ,category)
                             (br)
                             ,(if (equal? topics "")
                                  `(span)
                                  `(div
                                    ,@(map (lambda (topic)
                                             `(small ((class "post-topic"))
                                                     ,topic))
                                           (string-split topics))))
                             (p ,description "..."))))
                  posts)))))

;; Handler for the /blog/{category} path.
(define (list-posts request category)
  (define posts (db-select-category-posts db-conn category))
  void)

;; Handler for the /blog/{category}/{id}/{url-title} path.
(define (review-post request category id url-title)
  (define post (db-select-post db-conn id url-title category))
  (render-page
   request
   #:title (vector-ref post 1)
   #:desc (string-append (vector-ref post 5) "...")
   #:theme "dark"
   #:params post
   (lambda (post)
     `(div ((class "blog-post"))
           (h1 ,(vector-ref post 1))
           (small "Created at: " ,(timestamp->string (vector-ref post 7)))
           (p ,(vector-ref post 6))))))
   