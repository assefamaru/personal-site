#lang racket

(require db)

(provide port db-conn)

(define server
  (if (getenv "SERVER")
      (getenv "SERVER")
      "localhost"))

(define port
  (if (getenv "PORT")
      (string->number (getenv "PORT"))
      3000))

(define database
  (getenv "DATABASE"))

(define user
  (getenv "USER"))

(define password
  (getenv "PASSWORD"))

(define db-conn
  (virtual-connection
   (connection-pool
    (lambda () (mysql-connect #:server server
                              #:port port
                              #:database database
                              #:user user
                              #:password password)))))

(define (db-setup)
  "...")