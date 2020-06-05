#lang racket/base

(require "render.rkt")

(provide error/404)

(define (error/404 request)
  (render/page request `(div)))