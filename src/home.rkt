#lang racket

(require "header.rkt"
         web-server/servlet)

(provide/contract (render-home (request? . -> . response?)))

(define (render-home request)
  (response/xexpr
   `(html ,(meta "Alexander Maru")
          (body
           (p "Home page!")
           (a ((href "/blog"))
              "see blog page!")))))