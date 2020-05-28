#lang racket/base

(require db
         racket/string)

(provide timestamp->string
         string-split)

;; parse-date : sql-timestamp? -> string?
;; Consumes a sql-timestamp and produces a web
;; presentable string of the time.
(define (timestamp->string ts)
  (define year (sql-timestamp-year ts))
  (define month (vector-ref #("Jan"
                              "Feb"
                              "Mar"
                              "Apr"
                              "May"
                              "Jun"
                              "Jul"
                              "Aug"
                              "Sep"
                              "Oct"
                              "Nov"
                              "Dec")
                            (sub1 (sql-timestamp-month ts))))
  (define day (sql-timestamp-day ts))
  (string-append month
                 " "
                 (number->string day)
                 ", "
                 (number->string year)))