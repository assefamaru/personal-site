#lang racket/base

(require web-server/dispatch
         "notifications.rkt"
         "auth.rkt"
         "home.rkt"
         "blog.rkt")

(provide route)

;; URL dispatching rules for site routes.
(define-values (route request)
  (dispatch-rules
   [("") root-path]
   [("blog") blog-path]
   [("blog" (string-arg)) list-posts]
   [("blog" (string-arg) (integer-arg) (string-arg)) review-post]

   [("login") login-path]
   [("auth") auth-dispatch]
   [("auth" (string-arg)) auth-dispatch]
   [("auth" (string-arg) (string-arg)) auth-dispatch]
   [("auth" (string-arg) (integer-arg)) auth-dispatch]
   [("auth" (string-arg) (string-arg) (string-arg)) auth-dispatch]
   [else error/404]))