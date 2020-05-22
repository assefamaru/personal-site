#lang racket

(require web-server/formlets/stateless
         web-server/servlet
         "render.rkt"
         "models.rkt"
         "db.rkt"
         "blog.rkt")

(provide forms/login
         forms/create-post)

;; Formlets ================================================

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

;; Handlers ================================================

(define (forms/create-post request)
  (send/formlet new-post-formlet
                #:wrap render-page))


(define (f request)
  (define (response-generator embed/url)
    (render-page request
                 (lambda ()
                   `(div ((class "blog-form"))
                         (form ((action ,(embed/url insert-post-handler))
                                (method "POST"))
                               ,@(formlet-display new-post-formlet)
                               (input ((type "submit"))))))))
  (define (insert-post-handler request)
    (define-values (title category topics description body)
      (formlet-process new-post-formlet request))
    (db-insert-post! db-conn title category topics description body)
    (redirect/get))
  (send/formlet response-generator))


(define (forms/login request)
  void)
(define (forms/update-post request)
  void)                  
(define (forms/create-draft request)
  void)
(define (forms/update-draft request)
  void)