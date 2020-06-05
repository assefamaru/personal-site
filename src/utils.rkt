#lang racket/base

(require dotenv)

(provide call/getenv
         call/dotenv)

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