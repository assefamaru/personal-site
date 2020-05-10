#lang racket/base

(require "render.rkt"
         web-server/servlet)

(provide error-bad-request
         error-unauthorized
         error-not-found
         error-internal-server)

(define (error-bad-request request)
  (render-page request
               #:error #t
               #:code 400
               #:message "Bad Request"
               bad-request
               #:params request))

(define (error-unauthorized request)
  (render-page request
               #:error #t
               #:code 401
               #:message "Unauthorized"
               unauthorized
               #:params request))

(define (error-not-found request)
  (render-page request
               #:error #t
               #:code 404
               #:message "Not Found"
               not-found
               #:params request))

(define (error-internal-server request)
  (render-page request
               #:error #t
               #:code 500
               #:message "Internal Server Error"
               internal-server-error
               #:params request))

;; Error type 400: bad request.
(define (bad-request request)
  (error/xexpr "Bad Request."))

;; Error type 401: unauthorized.
(define (unauthorized request)
  (error/xexpr "Unauthorized."))

;; Error type 404: not found.
(define (not-found request)
  (error/xexpr `(p "The requested URL "
                   (strong ,(url->string (request-uri request)))
                   " was not found on this server.")))

;; Error type 500: internal server error.
(define (internal-server-error request)
  (error/xexpr "Internal Server Error."))

;; error/xexpr : string? -> xexpr
;; Produces an error component to be displayed
;; on the web when something has gone wrong.
(define (error/xexpr message)
  `(div ((class "error"))
        (h1 (strong "Oops!"))
        (p ,message)
        (p "Go back to " (a ((href "/")) "home page") ".")))