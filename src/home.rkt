#lang racket

(require "meta.rkt"
         "header.rkt"
         "sidebar.rkt"
         web-server/servlet)

(provide/contract (root-path (request? . -> . response?)))

(define (root-path request)
  (response/xexpr
   `(html ,(meta)
          (body
           ,(vertical-lines)
           ,(menu)
           ,(sidebar)
           ,(sidebar-right)
           ; Enter page content here =====
           ;(i ((data-feather "circle")))
           ; End of page content =========
           ))))