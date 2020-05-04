#lang racket

(require "meta.rkt"
         "sidebar.rkt"
         web-server/servlet)

(provide render-error)

(define (render-error request)
  (response/xexpr
   `(html ,(meta)
          (body
           ,(vertical-lines)
           ,(sidebar)
           (p "404: Page Not Found")))))