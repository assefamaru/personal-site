#lang racket/base

(require web-server/formlets
         web-server/http/redirect
         web-server/servlet/web
         "db.rkt"
         "models.rkt"
         "render.rkt"
         "errors.rkt")

(provide login-path
         blog-create-post)

;; login-path : request? -> response
(define (login-path request)
  void)

;; Formlet for new posts.
(define new-post-formlet
  (formlet
   (#%# ,((to-string
           (required
            (text-input
             #:attributes '((class "form-text")))))
          . => . title)
        ,((to-string
           (required
            (text-input
             #:attributes '((class "form-text")))))
          . => . category)
        ,((to-string
           (required
            (text-input
             #:attributes '((class "form-text")))))
          . => . topics)
        ,((to-string
           (required
            (text-input
             #:attributes '((class "form-text")))))
          . => . description)
        ,((to-string
           (required
            (text-input
             #:attributes '((class "form-text")))))
          . => . body))
   (values title category topics description body)))

;; blog-create-post : request? -> response
;; Displays a private web form for creating new posts.
(define (blog-create-post request)
  (define (response-generator embed/url)
    (render-page
     request
     (lambda ()
       `(div ((class "blog-form"))
             (form ((action ,(embed/url insert-post-handler)))
                   ,@(formlet-display new-post-formlet)
                   (input ((type "submit"))))))))
  (define (insert-post-handler request)
    (define-values (title category topics description body)
      (formlet-process new-post-formlet request))
    (cond
      ((or (equal? title "")
           (equal? category "")
           (equal? description "")
           (equal? body ""))
       (error/500 request "You can't submit the form without filling out all non-empty fields."))
      (else
       (db-insert-post! db-conn title category topics description body)
       (redirect-to "/r" see-other))))
  (send/suspend/dispatch response-generator))