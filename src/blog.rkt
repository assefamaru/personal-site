#lang racket/base

(require racket/vector
         "db.rkt"
         "model.rkt"
         "render.rkt"
         "status.rkt"
         "utils.rkt")

(provide blog-path
         list-posts
         review-post)

;; Handler for the "/blog" path.
(define (blog-path request)
  (define posts (db-select-partial-posts db-conn))
  (if (null? posts)
      (error/404 request
                 #:title "404 (Not Found)"
                 #:message "No posts found in database.")
      (render/page request
                   #:title "Blog"
                   #:params posts
                   blog-posts)))

;; Handler for the "/blog/{category}" path.
(define (list-posts request category)
  (define posts (db-select-category-posts db-conn category))
  (if (null? posts)
      (error/404 request
                 #:title "404 (Not Found)"
                 #:message "No posts found in database for this category.")
      (render/page request
                   #:title "Blog posts"
                   #:params posts
                   blog-posts)))

;; Handler for the "/blog/{category}/{id}/{title}" path.
(define (review-post request category id url-title)
  (define post (db-select-post db-conn id url-title category))
  (cond
    ((not post)
     (error/404 request
                #:title "404 (Not Found)"
                #:message "Post not found. Go back to home page."))
    (else
     (define-values (title topics description body created-at)
       (values (vector-ref post 1)
               (vector-ref post 4)
               (vector-ref post 5)
               (vector-ref post 6)
               (parse/timestamp (vector-ref post 7))))
     (render/page request
                  #:title title
                  #:description (string-append description "...")
                  (λ ()
                    `(div ((class "blog-post"))
                          (h1 ,title)
                          (small ,created-at)
                          (small " • " ,category)
                          (small " • " ,(reading-time body) " min read")
                          (br)
                          ,(if (equal? topics "")
                               `(span)
                               `(div
                                 ,@(map (λ (topic)
                                          `(small ((class "post-topic"))
                                                  ,topic))
                                        (string-split topics))))
                          ,@(map (λ (x)
                                   `(p ,x))
                                 (string-split body "\n"))))))))

;; blog-posts : (listof vector) -> xexpr
(define (blog-posts posts)
  `(div ((class "posts-wrapper"))
        ,@(map
           (λ (post)
             (define-values
               (id title url-title category topics description created-at)
               (values (number->string (vector-ref post 0))
                       (vector-ref post 1)
                       (vector-ref post 2)
                       (vector-ref post 3)
                       (vector-ref post 4)
                       (vector-ref post 5)
                       (parse/timestamp (vector-ref post 6))))
             `(a ((href ,(string-append "/blog/" category "/" id "/" url-title))
                  (class "post-item"))
                 (div (h3 ,title)
                      (small ,created-at)
                      (small " • " ,category)
                      (br)
                      ,(if (equal? topics "")
                           `(span)
                           `(div ,@(map (λ (topic)
                                          `(small ((class "post-topic"))
                                                  ,topic))
                                        (string-split topics))))
                      (p ,description "..."))))
           posts)))