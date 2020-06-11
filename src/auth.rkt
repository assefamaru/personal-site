#lang racket/base

(require web-server/formlets
         web-server/http/redirect
         web-server/http/request-structs
         web-server/http/bindings
         racket/match
         net/url
         web-server/http/cookie-parse
         "render.rkt"
         "utils.rkt")

(provide login-path
         dashboard-path)

;; Authenticated user and password.
(define admin-user (call/getenv "admin_user"))
(define admin-pass (call/getenv "admin_pass"))

;; authenticated? : request? -> boolean?
(define (authenticated? request)
  (match (request-headers request)
    [(cons 'authenticated _) #t]
    [else #f]))

;; Login formlet.
(define new-login-formlet
  (formlet
   (#%# ,((to-string
           (required
            (text-input
             #:attributes '((class "login-input")
                            (placeholder "Email")
                            (autocomplete "off")
                            (required "")
                            (autofocus "")))))
          . => . email)
        ,((to-string
           (required
            (password-input
             #:attributes '((class "login-input")
                            (placeholder "Password")
                            (autocomplete "off")
                            (required "")))))
          . => . password))
   (values email password)))

;; Handler for the "/login" path.
(define (login-path request)
  (define (login-handler request)
    (define-values (email password)
      (formlet-process new-login-formlet request))
    (if (and (equal? email admin-user)
             (equal? password admin-pass))
        (redirect-to "/dashboard" see-other)
        (redirect-to "/login" see-other)))
  (if (bytes=? (request-method request) #"POST")
      (login-handler request)
      (render/page request
                   #:title "Log In"
                   (λ ()
                     `(div ((class "login"))
                           (form ((action ,(url->string (request-uri request)))
                                  (method "post"))
                                 ,@(formlet-display new-login-formlet)
                                 (input ((type "submit")
                                         (class "submit")))))))))

;; Handler for the "/dashboard" path.
(define (dashboard-path request)
  (if (not (authenticated? request))
      (redirect-to "/login" see-other)
      (render/page request
                   #:title "Dashboard"
                   (λ ()
                     `(div ((class "dashboard"))
                           "Private dashboard")))))