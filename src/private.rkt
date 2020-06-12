#lang racket/base

(require web-server/http/redirect
         "auth.rkt"
         "db.rkt"
         "render.rkt"
         "model.rkt"
         "status.rkt")

(provide private-dispatch)

;; private-dispatch routes authenticated URLs to
;; corresponding handler methods.
(define (private-dispatch request . args)
  (define len (length args))
  (cond
    [(authenticated? request)
     (redirect-to "/login" see-other)]
    [(= len 0)
        (dashboard-path request)]
    [(and (= len 1)
          (equal? (car args) "drafts"))
     (list-drafts request)]
    [(and (= len 2)
          (equal? (car args) "db")
          (equal? (cadr args) "create"))
     (create-db request)]
    [(and (= len 2)
          (equal? (car args) "db")
          (equal? (cadr args) "migrate"))
     (migrate-db request)]
    [(and (= len 2)
          (equal? (car args) "db")
          (equal? (cadr args) "drop"))
     (drop-db request)]
    [(and (= len 2)
          (equal? (car args) "posts")
          (equal? (cadr args) "create"))
     (create-post request)]
    [(and (= len 2)
          (equal? (car args) "drafts")
          (number? (cadr args)))
     (edit-draft request (cadr args))]
    [else
     (error/404 request)]))

;; Handler for the "/dashboard" path.
(define (dashboard-path request)
  (render/page request
               #:title "Dashboard"
               (λ ()
                 `(div ((class "dashboard"))
                       (h3 "Blog Post")
                       (ul (li (a ((href "/dashboard/posts/create"))
                                  "Create Post"))
                           (li (a ((href "/dashboard/drafts"))
                                  "List Drafts")))
                       (h3 "Database")
                       (ul (li (a ((href "/dashboard/db/create"))
                                  "Create DB"))
                           (li (a ((href "/dashboard/db/migrate"))
                                  "Migrate DB"))
                           (li (a ((href "/dashboard/db/drop"))
                                  "Drop DB")))))))

;; create-db : request? -> ...
(define (create-db request)
  (render/page request
               (lambda ()
                 `(div "Create DB"))))

;; migrate-db : request? -> ...
(define (migrate-db request)
  (render/page request
               (lambda ()
                 `(div "Migrate DB"))))

;; drop-db : request? -> ...
(define (drop-db request)
  (render/page request
               (lambda ()
                 `(div "Drop DB"))))

;; create-post : request -> ...
(define (create-post request)
  (render/page request
               (lambda ()
                 `(div "Create Post"))))

;; Handler for the "/dashboard/drafts/{id}" path.
(define (edit-draft request post-id)
  (render/page request
               (lambda ()
                 `(div "Edit post"))))

;; Handler for the "/dashboard/drafts" path.
(define (list-drafts request)
  (define drafts (db-select-drafts db-conn))
  (render/page request
               (lambda ()
                 `(div "List drafts"))))