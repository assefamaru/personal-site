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
;; Finds the value of the environment
;; variable 'var', either from the local
;; environment, or from the dotenv file
;; specified in call/dotenv.
(define (find-env var)
  (if (getenv var)
      (getenv var)
      (call/dotenv var)))

;; MySQL server host.
(define server (find-env "DBHOST"))

;; MySQL database name.
(define database (find-env "DBNAME"))

;; MySQL user credential.
(define user (find-env "DBUSER"))

;; MySQL password credential.
(define password (find-env "DBPASS"))

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