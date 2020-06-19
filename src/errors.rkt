#lang racket/base

(require "render.rkt")

(provide success/200
         error/404)

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
                   #:message [message "Page not found"])
  (render/page request
               #:code 404
               #:title title
               (λ () `(div ,message))))