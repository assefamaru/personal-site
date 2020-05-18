#lang racket/base

(require web-server/dispatch
         "db.rkt"
         "model.rkt"
         "home.rkt"
         "blog.rkt"
         "render.rkt"
         "notifs.rkt")

(provide route)

;; URL dispatching rules for site routes.
(define-values (route request)
  (dispatch-rules
   [("") root-path]
   [("blog") blog-path]
   [("blog" (string-arg)) list-posts]
   [("blog" (string-arg) (string-arg)) list-category-posts]
   [("blog" (string-arg) (string-arg) (integer-arg) (string-arg)) review-post]
   [("sudo" (string-arg)) sudo]
   [else error-not-found]))

(define (sudo request path)
  (cond
    ((equal? path "update-db")
     (update-db! db-conn)
     (render-page request
                  (lambda ()
                    `(div ((class "notifs"))
                          (h1 "Success!")
                          (p "Database has been updated.")))))
    (else (error-not-found request))))