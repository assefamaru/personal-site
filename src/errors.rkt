#lang racket/base

(require net/url
         web-server/http/request-structs
         "render.rkt")

(provide success/200
         error/404
         error/500)

(define (error/500 request message)
  (render-page request
               #:code 500
               #:message "Internal Server Error"
               (lambda ()
                 `(div ((class "errors"))
                       (h1 (strong "Oops!"))
                       (p ,message)
                       (p "Go back to " (a ((href "/")) "home page") ".")))))

(define (success/200 request)
  (render-page request
               #:code 200
               #:message "Success"
               (lambda ()
                 (success/xexpr "Your command has successfully finished running."))))

(define (error/404 request)
  (render-page request
               #:error #t
               #:code 404
               #:message "Not Found"
               #:params request
               (lambda (req)
                 (error/xexpr
                  `(p "The requested URL "
                      (strong ,(url->string (request-uri req)))
                      " was not found on this server.")))))

(define (success/xexpr message)
  `(div ((class "errors"))
        (h1 (strong "Yayy!"))
        (p ,message)
        (p "Go back to " (a ((href "/")) "home page") ".")))

;; error/xexpr : string? -> xexpr
;; Produces an error component to be displayed
;; on the web when something has gone wrong.
(define (error/xexpr message)
  `(div ((class "errors"))
        (h1 (strong "Oops!"))
        (p ,message)
        (p "Go back to " (a ((href "/")) "home page") ".")))