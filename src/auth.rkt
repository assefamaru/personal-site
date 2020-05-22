#lang racket

(require web-server/servlet
         "notifications.rkt"
         "models.rkt"
         "forms.rkt"
         "db.rkt")

(provide login-path
         auth-dispatch)

;; login-path : request? -> response
(define (login-path request)
  (error/404 request))

;; auth-dispatch : request? (listof string?) -> response
(define (auth-dispatch request . args)
  (define len (length args))
  (cond
    ((= len 0)
     (error/404 request))
    ((= len 1)
     (cond
       ((equal? (car args) "drafts")
        (db-select-drafts db-conn))
       ((equal? (car args) "create-post")
        (forms/create-post request))
       (else (error/404 request))))
    ((= len 2)
     (cond
       ((and (equal? (car args) "db")
             (equal? (cadr args) "create"))
        (db-create! db-conn)
        (success/200 request))
       ((and (equal? (car args) "db")
             (equal? (cadr args) "destroy"))
        (db-destroy! db-conn)
        (success/200 request))
       ((and (equal? (car args) "drafts")
             (integer? (cadr args)))
        (db-select-draft db-conn (cadr args)))
       (else (error/404 request))))
    ((= len 3)
     (cond
       ((and (equal? (car args) "db")
             (equal? (cadr args) "drop"))
        (db-drop! db-conn (caddr args)))
       (else (error/404 request))))
    (else (error/404 request))))