#lang racket

(require "meta.rkt"
         "header.rkt"
         "sidebar.rkt"
         web-server/servlet)

(provide render-error)

(define (render-error request)
  (response/xexpr
   `(html ,(meta)
          (body
           ,(vertical-lines)
           ,(menu)
           ,(sidebar)
           (p "404: Page Not Found")))))