#lang racket/base

(require "render.rkt"
         web-server/servlet)

(provide render-error)

(define (render-error request)
  (render-page request error-body))

(define (error-body)
  `(p "404: Page Not Found"))