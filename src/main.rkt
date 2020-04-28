#lang racket

(require web-server/servlet
         web-server/servlet-env)

(define (start req)
  (response/xexpr
   `(html (head (title "Alexander Maru"))
          (body (p "Hello, world!")))))

(define port
  (if (getenv "PORT")
      (string->number (getenv "PORT"))
      3000))

(serve/servlet start
               #:command-line? #t ;; set this to #t on deploy
               #:listen-ip #f
               #:port port
               #:servlet-path "/")