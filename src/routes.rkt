#lang racket/base

(require web-server/dispatch
         "notifications.rkt"
         "home.rkt"
         "blog.rkt")

(provide route)

;; URL dispatching rules for site routes.
(define-values (route request)
  (dispatch-rules
   [("") root-path]))