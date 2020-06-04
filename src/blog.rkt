#lang racket/base

(require "render.rkt"
         "models.rkt"
         "utils.rkt"
         "db.rkt")

(provide blog-path
         list-posts
         list-drafts
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
                    (define topics (vector-ref post 3))
                    (define description (vector-ref post 4))
                    (define created-at (timestamp->string (vector-ref post 5)))
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

;; Handler for the /blog/{category}/{id}/{url-title} path.
(define (review-post request category id url-title)
  (define post (db-select-post db-conn id url-title category))
  (define title (vector-ref post 1))
  (define topics (vector-ref post 4))
  (define description (vector-ref post 5))
  (define body (vector-ref post 6))
  (define created-at (timestamp->string (vector-ref post 7)))
  (render-page
   request
   #:title (vector-ref post 1)
   #:desc (string-append description "...")
   #:theme "dark"
   #:params post
   (lambda (post)
     `(div ((class "blog-post"))
           (h1 ,title)
           (small ,created-at)
           (small " • " ,category)
           (small " • " ,(reading-time body) " min read")
           (br)
           ,(if (equal? topics "")
                `(span)
                `(div
                  ,@(map (lambda (topic)
                           `(small ((class "post-topic"))
                                   ,topic))
                         (string-split topics))))
           ,@(map (lambda (x)
                    `(p ,x))
                  (string-split body "\n"))))))

;; Handler for the /auth/drafts path.
(define (list-drafts request)
  void)