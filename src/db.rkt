#lang racket/base

(require db
         "utils.rkt")

(provide db-conn)

;; MySQL user credential
(define user (find-env "DBUSER"))

;; MySQL password credential
(define password (find-env "DBPASS"))

;; MySQL database name
(define database (find-env "DBNAME"))

;; MySQL server host
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