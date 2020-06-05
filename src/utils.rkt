#lang racket/base

(require db
         dotenv
         racket/string)

(provide call/getenv
         call/dotenv
         parse/timestamp
         count/word
         count/char
         reading-time)

;; call/getenv : string? -> string?
;; Get the environment variable 'var'
;; either from local, or from '.env'.
(define (call/getenv var)
  (if (getenv var)
      (getenv var)
      (call/dotenv var)))

;; call/dotenv : string? [ string? ] -> string?
;; Get the environment variable 'var' from path.
(define (call/dotenv var [path "../.env"])
  (define env (dotenv-read path))
  (parameterize ([current-environment-variables env])
    (getenv var)))

;; parse/timestamp : sql-timestamp? -> string?
;; Consumes a sql-timestamp and produces a web
;; presentable string of the time.
(define (parse/timestamp ts)
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

;; count/word : string? -> integer?
;; Consumes a string and produces the number of
;; words in that string.
(define (count/word str)
  (length (string-split str)))

;; count/char : string? -> integer?
;; Consumes a string and produces the number of
;; characters in that string.
(define (count/char str)
  (length (string->list str)))

;; reading-time : string? [ integer? ] -> string?
;; Consumes a string and returns the length of time
;; needed to read that string. This is calculated
;; using the given words-per-minute read.
(define (reading-time str [words-per-minute 275])
  (define words (count/word str))
  (car (string-split
        (number->string (ceiling (/ words words-per-minute)))
        ".")))