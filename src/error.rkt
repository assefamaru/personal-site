#lang racket

(require "header.rkt"
         web-server/servlet)

(provide error-path)

(define (error-path request)
  (response/xexpr
   `(html ,(meta "Alexander Maru")
          (body
           (p "404: Page Not Found")))))