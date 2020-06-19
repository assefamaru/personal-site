#lang racket/base

(require web-server/http/bindings
         racket/match
         "utils.rkt")

(provide authenticated?
         admin-user
         admin-pass)

;; Authenticated user and password.
(define admin-user (call/getenv "admin_user"))
(define admin-pass (call/getenv "admin_pass"))

;; Temporary auth function.
(define (authenticated? request) #t)

;; authenticated? : request? -> boolean?
(define (new-authenticated? request)
  (match (request-headers request)
    [(cons 'authenticated _) #t]
    [else #f]))