#lang racket

(provide menu)

(define (menu)
  `(header ((class "header"))
           (a ((href "/")
               (class "hdrlink hdrlink1"))
              "Home")
           (a ((href "/blog")
               (class "hdrlink hdrlink2"))
              "Blog")))