#lang racket/base

(require "render.rkt")

(provide error/404)

;; Page not found (404) error response.
(define (error/404 request
                   #:title [title "Page not found"]
                   #:message [message "Page not found"])
  (render/page request
               #:code 404
               #:title title
               (λ () `(div ,message))))