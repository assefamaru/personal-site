#lang racket

(require "meta.rkt"
         web-server/servlet)

(provide/contract (root-path (request? . -> . response?)))

(define (root-path request)
  (response/xexpr
   `(html ,(meta)
          (body
           (p "Home page!")
           (a ((href "/blog"))
              "see blog page!")))))