#lang racket/base

(require "meta.rkt"
         "header.rkt"
         "sidebar.rkt"
         "footer.rkt"
         web-server/servlet)

(provide render-error)

(define (render-error request)
  (response/xexpr
   `(html ,(meta)
          (body
           ,(vertical-lines)
           ,(menu)
           ,(sidebar)
           ,(sidebar-right)
           ,(footer)
           (p "404: Page Not Found")))))