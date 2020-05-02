#lang racket

(require "header.rkt"
         web-server/servlet)

(provide/contract (root-path (request? . -> . response?)))

(define (root-path request)
  (response/xexpr
   `(html ,(meta "Alexander Maru")
          (body
           (p "Home page!")
           (a ((href "/blog"))
              "see blog page!")))))