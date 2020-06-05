#lang racket/base

(require db
         "utils.rkt")

(provide db-conn)

;; MySQL user
(define user (call/getenv "DBUSER"))

;; MySQL password
(define password (call/getenv "DBPASS"))

;; MySQL database name
(define database (call/getenv "DBNAME"))

;; MySQL server host
(define server (call/getenv "DBHOST"))

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