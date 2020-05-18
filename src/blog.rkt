#lang racket/base

(require "model.rkt"
         "db.rkt"
         "render.rkt"
         "notifs.rkt"
         racket/vector
         web-server/servlet)

(provide blog-path
         list-posts
         list-category-posts
         review-post
         list-drafts
         review-draft)

;; Handler for the /blog path.
(define (blog-path request)
  (define posts (blog-list-posts db-conn))
  (if (null? posts)
      (error-not-found request)
      (render-page request
                   #:title "Posts"
                   #:params posts
                   blog-posts)))

;; Handler for the /blog/posts path.
(define (list-posts request path)
  (cond
    ((equal? path "posts")
     (define posts (blog-list-posts db-conn))
     (if (null? posts)
         (error-not-found request)
         (render-page request
                      #:title "Posts"
                      #:params posts
                      blog-posts)))
    (else (error-not-found request))))

(define (list-category-posts request) void)

;; Handler for the /blog/posts/{category}/{id}/{title} path.
(define (review-post request category post-id title)
  (define post (blog-retrieve-post db-conn post-id title category))
  (if (vector-empty? post)
      (error-not-found request)
      (render-page request
                   #:title title
                   #:params post
                   blog-post)))

;; blog-page consumes a categorized list of posts,
;; and produces a xexpr for the page to render.
(define (blog-page posts)
  `(section ((class "blog-posts"))
            (ul ,@(map (lambda (post)
                         `(li ,(vector-ref post 1)))
                       posts))))

;; blog-posts consumes a list of posts,
;; and produces a xexpr for the page to render.
(define (blog-posts posts)
  `(section ((class "blog-posts"))
            (ul ,@(map (lambda (post)
                         `(li ,(vector-ref post 1)))
                       posts))))

;; blog-post consumes a post and produces a xexpr for the page to render.
;; post is a vector with the following structure:
;; '#(id title body category description topics created_at updated_at)
;;     0   1    2      3          4        5       6           7
(define (blog-post post)
  `(section ((class "blog-text"))
            (h1 ((class "title"))
                ,(vector-ref post 1))
            (small "Last updated: " ,(vector-ref post 7))
            (p "Topics: " ,(vector-ref post 5))
            (p ((class "body"))
               ,(vector-ref post 2))))

;; ====================================================================================

;; Handler for the /blog/drafts path.
(define (list-drafts request)
  (define drafts (blog-list-drafts db-conn))
  (if (null? drafts)
      (error-not-found request)
      (render-page request
                   #:title "Drafts"
                   #:params drafts
                   blog-drafts)))

;; Handler for the /blog/drafts/{category}/{id}/{title} path.
(define (review-draft request category draft-id title)
  (define draft (blog-retrieve-draft db-conn draft-id title category))
  (if (vector-empty? draft)
      (error-not-found request)
      (render-page request
                   #:title title
                   #:params draft
                   blog-draft)))

;; blog-drafts consumes a list of drafts,
;; and produces a xexpr for the page to render.
(define (blog-drafts drafts)
  `(section ((class "blog-drafts"))
            (ul ,@(map (lambda (draft)
                         `(li ,(vector-ref draft 1)))
                       drafts))))

;; blog-draft consumes a draft and produces a xexpr for the page to render.
;; draft is a vector with the following structure:
;; '#(id title body category description topics created_at updated_at)
;;     0   1    2      3          4        5       6           7
(define (blog-draft draft)
  `(section ((class "blog-text"))
            (h1 ((class "title"))
                ,(vector-ref draft 1))
            (small "Last updated: " ,(vector-ref draft 7))
            (p "Topics: " ,(vector-ref draft 5))
            (p ((class "body"))
               ,(vector-ref draft 2))))

;; ====================================================================================