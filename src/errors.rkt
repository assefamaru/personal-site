#lang racket/base

(require "render.rkt")

(provide success/200
         error/404
         error/500)

;; Success (200) status response.
(define (success/200 request
                     #:title [title "Success!"]
                     #:message [message "Success!"])
  (render/page request
               #:code 200
               #:title title
               (λ () `(div ,message))))

;; Error (404) status response.
(define (error/404 request
                   #:title [title "Page not found"]
                   #:message [message "Page not found!"])
  (render/page request
               #:code 404
               #:title title
               (λ () `(div ,message))))

;; Error (500) status response.
(define (error/500 request
                   #:title [title "Internal Server Error"]
                   #:message [message "Unknown error occurred!"])
  (render/page request
               #:code 500
               #:title title
               (λ () `(div ,message))))