#lang racket/base

(require db
         dotenv
         openssl/md5
         racket/string)

(provide call/getenv
         call/dotenv
         parse/timestamp
         count/word
         count/char
         pluralize
         gravatar-url
         reading-time
         string-split)

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
  (define year (number->string (sql-timestamp-year ts)))
  (define month
    (vector-ref #("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
                (sub1 (sql-timestamp-month ts))))
  (define day (number->string (sql-timestamp-day ts)))
  (string-append month " " day ", " year))

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

;; pluralize : integer? string? [ string? ] -> string?
;; Returns the plural form of str using grammar if
;; num != 1, and its singular form otherwise. 
(define (pluralize num str [grammar "s"])
  (define num-str (number->string num))
  (if (= num 1)
      (string-append num-str " " str)
      (string-append num-str " " str grammar)))

;; gravatar-url : string? [ integer? ] -> string?
;; Generates the gravatar image url for an email.
(define (gravatar-url email [size 50])
  (string-append
   "//gravatar.com/avatar/"
   (md5 (open-input-string
         (string-downcase email)))
   "?s="
   (number->string size)))

;; reading-time : string? [ integer? ] -> string?
;; Consumes a string and returns the length of time
;; needed to read that string. This is calculated
;; using the given words-per-minute read.
(define (reading-time str [words-per-minute 275])
  (define words (count/word str))
  (car (string-split (number->string (ceiling (/ words words-per-minute))) ".")))