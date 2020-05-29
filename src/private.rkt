#lang racket/base

(require "db.rkt"
         "auth.rkt"
         "render.rkt"
         "models.rkt"
         "forms.rkt"
         "errors.rkt")

(provide private-path)

;; private-path : request? (listof string?) -> response
;; Acts as a URL dispatcher for all private methods.
(define (private-path request . args)
  ;; Make sure request is authenticated
  ;; here before proceeding below
  (define len (length args))
  (cond
    [(= len 0)
     (private-dashboard request)]
    [(= len 2)
     (cond
       ((and (equal? (car args) "db")
             (equal? (cadr args) "create"))
        (db-create! db-conn)
        (success/200 request))
       ((and (equal? (car args) "db")
             (equal? (cadr args) "drop"))
        (db-destroy! db-conn)
        (success/200 request))
       ((and (equal? (car args) "posts")
             (equal? (cadr args) "create"))
        (blog-create-post request))
       (else (error/404 request)))]
    [else (error/404 request)]))

;; private-dashboard : request? -> response
;; This page lists all private methods allowed in app,
;; with active links to each.
(define (private-dashboard request)
  (render-page
   request
   #:theme "dark"
   (lambda ()
     `(div ((class "auth-links-wrapper"))
           (ul (li (a ((href "/auth/db/create"))
                      "Create database"))
               (li (a ((href "/auth/db/drop"))
                      "Drop database"))
               (li (a ((href "/auth/posts/create"))
                      "Create new post")))))))