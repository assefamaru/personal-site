#lang racket

(require css-expr
         web-server/servlet)

(provide dark-theme light-theme render-styles)

(define dark-theme
  (css-expr->css
   (css-expr
    [body
     #:margin 0
     #:padding 0
     #:background-color |gold|
     #:color |black|
     #:font-family |"Source Sans Pro"|]
    [a #:color |green|]
    [a:hover #:color |red|])))

(define light-theme
  (css-expr->css
   (css-expr
    [body
     #:margin 0
     #:padding 0
     #:background-color |#f7f7f7|
     #:color |#333|
     #:font-family |"Source Sans Pro"|]
    [a #:color |blue|]
    [a:hover #:color |red|])))

(define render-styles
  (css-expr->css
   (css-expr
    [p #:color |grey|])))