#lang racket/base

(require net/url
         web-server/http/request-structs
         "render.rkt")

(provide success/200
         error/404
         error/500)

;; Status 200 : SUCCESS
(define (success/200 request)
  (render-page
   request
   #:code 200
   #:message "Success"
   (lambda ()
     `(div ((class "errors"))
           (h1 (strong "Yayy!"))
           (p "Your command has successfully finished running.")
           (p "Go back to " (a ((href "/")) "home page") ".")))))

;; Status 404 : NOT FOUND
(define (error/404 request)
  (render-page
   request
   #:error #t
   #:code 404
   #:message "Not Found"
   #:params request
   (lambda (req)
     `(div ((class "errors"))
           (h1 (strong "Oops!"))
           (p "The requested URL "
              (strong ,(url->string (request-uri req)))
              " was not found on this server.")
           (p "Go back to " (a ((href "/")) "home page") ".")))))

;; Status 500 : INTERNAL SERVER ERROR
(define (error/500 request [message "Internal Server Error"])
  (render-page request
               #:code 500
               #:message "Internal Server Error"
               (lambda ()
                 `(div ((class "errors"))
                       (h1 (strong "Oops!"))
                       (p ,message)
                       (p "Go back to " (a ((href "/")) "home page") ".")))))