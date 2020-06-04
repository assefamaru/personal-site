#lang racket/base

(require web-server/http/id-cookie
         web-server/http/cookie-parse
         racket/random
         web-server/http/bindings
         "utils.rkt")

(provide authenticate
         authenticated-user?
         authenticated-request?)

;; authenticate : request? -> void
;; Signs in a request using cookies.
(define authenticate
  (make-id-cookie "auth"
                  (crypto-random-bytes 128)
                  "value"
                  #:secure? #f))

;; authenticated-user? : string? string? -> boolean?
;; Returns #t if user/pass is valid, and #f otherwise.
(define (authenticated-user? user pass)
  (define secret-user (find-env "secret_user" "../.env"))
  (define secret-pass (find-env "secret_pass" "../.env"))
  (and (equal? user secret-user)
       (equal? pass secret-pass)))

;; authenticated-request? : request? -> boolean?
;; Returns #t if request is logged in, and #f otherwise.
(define (authenticated-request? request)
  (define cookies
    (extract-binding/single 'cookies (request-bindings request)))
  cookies)