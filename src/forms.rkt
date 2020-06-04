#lang racket/base

(require web-server/formlets
         web-server/http/redirect
         web-server/servlet/web
         "db.rkt"
         "auth.rkt"
         "models.rkt"
         "render.rkt"
         "errors.rkt")

(provide login-path
         blog-create-post
         blog-create-draft)

;; login-path : request? -> response
(define (login-path request)
  (define (response-generator embed/url)
    (render-page
     request
     #:theme "dark"
     (lambda ()
       `(div ((class "login-form"))
             (form ((action ,(embed/url insert-login-handler)))
                   ,@(formlet-display new-login-formlet)
                   (input ((type "submit"))))))))
  (define (insert-login-handler request)
    (define-values (user pass)
      (formlet-process new-login-formlet request))
    (cond
      ((authenticated-user? user pass)
       (authenticate request)
       (redirect-to "/auth" see-other))
      (else
       (login-path request))))
  (send/suspend/dispatch response-generator))

;; blog-create-post : request? -> response
;; Displays a private web form for creating new posts.
(define (blog-create-post request)
  (define (response-generator embed/url)
    (render-page
     request
     #:theme "dark"
     (lambda ()
       `(div ((class "blog-form"))
             (form ((action ,(embed/url insert-post-handler)))
                   ,@(formlet-display new-post-formlet)
                   (input ((type "submit"))))))))
  (define (insert-post-handler request)
    (define-values (title category topics body)
      (formlet-process new-post-formlet request))
    (cond
      ((or (equal? title "")
           (equal? category "")
           (equal? body ""))
       (error/500 request "You can't submit the form without filling out all required fields."))
      (else
       (db-insert-post! db-conn title category topics body)
       (redirect-to "/blog" see-other))))
  (send/suspend/dispatch response-generator))

(define (blog-create-draft request)
  (define (response-generator embed/url)
    (render-page
     request
     #:theme "dark"
     (lambda ()
       `(div ((class "blog-form"))
             (form ((action ,(embed/url insert-post-handler)))
                   ,@(formlet-display new-post-formlet)
                   (input ((type "submit"))))))))
  (define (insert-post-handler request)
    (define-values (title category topics body)
      (formlet-process new-post-formlet request))
    (db-insert-draft! db-conn title category topics body)
    (redirect-to "/blog" see-other))
  (send/suspend/dispatch response-generator))

;; Formlet for login auth.
(define new-login-formlet
  (formlet
   (#%# ,((to-string
           (required
            (text-input
             #:attributes '((class "login-form-text")
                            (placeholder "Username")
                            (autocomplete "off")))))
          . => . user)
        ,((to-string
           (required
            (password-input
             #:attributes '((class "login-form-text")
                            (placeholder "Password")
                            (autocomplete "off")))))
          . => . pass))
   (values user pass)))

;; Formlet for new posts.
(define new-post-formlet
  (formlet
   (#%# ,((to-string
           (required
            (textarea-input
             #:rows 1
             #:attributes '((class "form-text")
                            (placeholder "Title")
                            (autocomplete "off")))))
          . => . title)
        ,((to-string
           (required
            (textarea-input
             #:rows 1
             #:attributes '((class "form-text")
                            (placeholder "Category")
                            (autocomplete "off")))))
          . => . category)
        ,((to-string
           (required
            (textarea-input
             #:rows 1
             #:attributes '((class "form-text")
                            (placeholder "Topics")
                            (autocomplete "off")))))
          . => . topics)
        ,((to-string
           (required
            (textarea-input
             #:rows 30
             #:cols 10
             #:attributes '((class "form-text form-text-body")
                            (placeholder "Body")
                            (autocomplete "off")))))
          . => . body))
   (values title category topics body)))