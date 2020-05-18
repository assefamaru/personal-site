#lang racket/base

(require db
         dotenv)

(provide db-conn)

(define (call/dotenv var)
  (parameterize ([current-environment-variables (dotenv-read)])
    (getenv var)))

(define server
  (if (getenv "DBHOST")
      (getenv "DBHOST")
      (call/dotenv "DBHOST")))
  

(define port
  (if (getenv "PORT")
      (string->number (getenv "PORT"))
      (string->number (call/dotenv "DBPORT"))))

(define database
  (if (getenv "DBNAME")
      (getenv "DBNAME")
      (call/dotenv "DBNAME")))

(define user
  (if (getenv "DBUSER")
      (getenv "DBUSER")
      (call/dotenv "DBUSER")))

(define password
  (if (getenv "DBPASS")
      (getenv "DBPASS")
      (call/dotenv "DBPASS")))

;; Create connections on demand
;; in a connection pool.
(define db-conn
  (virtual-connection
   (connection-pool
    (lambda ()
      (mysql-connect #:server server
                     #:port port
                     #:database database
                     #:user user
                     #:password password)))))