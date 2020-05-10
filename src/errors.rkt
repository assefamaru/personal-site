#lang racket/base

(require "render.rkt"
         web-server/servlet)

(provide error-not-found)

(define (error-bad-request request)
  (render-page request #:error #t #:code 400 bad-request #:params request))

(define (error-unauthorized request)
  (render-page request #:error #t #:code 401 unauthorized #:params request))

(define (error-not-found request)
  (render-page request #:error #t #:code 404 not-found #:params request))

(define (error-internal-server request)
  (render-page request #:error #t #:code 500 internal-server-error #:params request))

;; Error type 400: bad request.
(define (bad-request request)
  (error/xexpr "400" "Bad Request"))

;; Error type 401: unauthorized.
(define (unauthorized request)
  (error/xexpr "401" "Unauthorized"))

;; Error type 404: not found.
(define (not-found request)
  (error/xexpr "404"
               "Not Found"
               `(p "The requested URL "
                   (strong ,(url->string (request-uri request)))
                   " was not found on this server.")))

;; Error type 500: internal server error.
(define (internal-server-error request)
  (error/xexpr "500" "Internal Server Error"))

;; error/xexpr : string? string? -> xexpr
;; Produces an error component to be displayed
;; on the web when something has gone wrong.
(define (error/xexpr code message [details #f])
  `(div ((class "error"))
        (h1 (strong ,code "!"))
        (p "Error status: " ,message ".")
        ,(unless (not details)
           details)
        (p "Go back to " (a ((href "/")) "home page") ".")))