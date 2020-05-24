#lang racket/base

(require db
         dotenv)

(provide db-conn)

;; call/dotenv : string? [ string? ] -> string?
;; Get environment variable 'var' from the
;; dotenv file specified by 'path'.
(define (call/dotenv var [path "../.env"])
  (define env (dotenv-read path))
  (parameterize ([current-environment-variables env])
    (getenv var)))

;; find-env : string? -> string?
;; Finds the value of the environment variable
;; 'var', either from local or from dotenv.
(define (find-env var)
  (if (getenv var)
      (getenv var)
      (call/dotenv var)))

;; MySQL credentials.
(define user (find-env "DBUSER"))
(define password (find-env "DBPASS"))
(define database (find-env "DBNAME"))
(define server (find-env "DBHOST"))

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