#lang racket/base

(require db
         dotenv
         racket/string)

(provide call/dotenv
         find-env
         string-split
         timestamp->string
         word-count
         reading-time)

;; call/dotenv : string? [ string? ] -> string?
;; Get environment variable 'var' from the
;; dotenv file specified by 'path'.
(define (call/dotenv var [path "../.env"])
  (define env (dotenv-read path))
  (parameterize ([current-environment-variables env])
    (getenv var)))

;; find-env : string? [ string? ] -> string?
;; Finds the value of the environment variable
;; 'var', either from local or from dotenv.
(define (find-env var [path "../.env"])
  (if (getenv var)
      (getenv var)
      (call/dotenv var path)))

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

;; word-count : string? -> integer?
;; Consumes a string and produces the number of
;; words in that string.
(define (word-count str)
  (length (string-split str)))

;; reading-time : string? [ integer? ] -> string?
;; Consumes a string and returns the length of time
;; needed to read that string. This is calculated
;; using the given words-per-minute read.
(define (reading-time str [words-per-minute 275])
  (define words (word-count str))
  (car (string-split
        (number->string (ceiling (/ words words-per-minute)))
        ".")))