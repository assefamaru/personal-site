#lang racket/base

(require "db.rkt"
         "auth.rkt"
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
     (r-path request)]
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

;; r-path : request? -> response
;; This page lists all private methods allowed in app,
;; with active links to each.
(define (r-path request)
  void)