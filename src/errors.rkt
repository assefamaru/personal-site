#lang racket

(require "meta.rkt"
         web-server/servlet)

(provide render-error)

(define (render-error request)
  (response/xexpr
   `(html ,(meta)
          (body
           (p "404: Page Not Found")))))