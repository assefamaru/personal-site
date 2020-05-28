#lang racket/base

(require db)

(provide timestamp->string)

;; parse-date : sql-timestamp? -> string?
;; Consumes a sql-timestamp and produces a web
;; presentable string of the time.
(define (timestamp->string ts)
  (define year (sql-timestamp-year ts))
  (define month (vector-ref #("January"
                              "February"
                              "March"
                              "April"
                              "May"
                              "June"
                              "July"
                              "August"
                              "September"
                              "October"
                              "November"
                              "December")
                            (sub1 (sql-timestamp-month ts))))
  (define day (sql-timestamp-day ts))
  (define hour (sql-timestamp-hour ts))
  (define min (sql-timestamp-minute ts))
  (define sec (sql-timestamp-second ts))
  (string-append month
                 " "
                 (number->string day)
                 ", "
                 (number->string year)
                 " "
                 (number->string hour)
                 ":"
                 (number->string min)
                 ":"
                 (number->string sec)))