#lang racket/base

(require db
         dotenv)

(provide db-conn)

;; Get environment variable 'var' from the
;; dotenv file specified by 'path'.
(define (call/dotenv var [path "../.env"])
  (define env (dotenv-read path))
  (parameterize ([current-environment-variables env])
    (getenv var)))

;; MySQL server host.
(define server (if (getenv "DBHOST")
                   (getenv "DBHOST")
                   "localhost"))

;; MySQL database.
(define database (if (getenv "DBNAME")
                     (getenv "DBNAME")
                     (call/dotenv "DBNAME")))

;; MySQL user.
(define user (if (getenv "DBUSER")
                 (getenv "DBUSER")
                 (call/dotenv "DBUSER")))

;; MySQL password.
(define password (if (getenv "DBPASS")
                     (getenv "DBPASS")
                     (call/dotenv "DBPASS")))

;; Create connections on demand
;; in a connection pool.
(define db-conn
  (virtual-connection
   (connection-pool
    (lambda ()
      (mysql-connect #:server server
                     #:port 3306
                     #:database database
                     #:user user
                     #:password password)))))