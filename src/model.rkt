#lang racket/base

(require db
         "db.rkt")

(define (initialize-db!)
  ; Create posts table if not present
  (unless (table-exists? db-conn "posts")
    (query-exec
     db-conn
     "...")))