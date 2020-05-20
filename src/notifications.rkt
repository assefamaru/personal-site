#lang racket/base

(require web-server/servlet
         "render.rkt")

(provide success/200
         error/400
         error/404
         error/500)

(define (success/200 request) void)

(define (error/400 request) void)
(define (error/404 request) void)
(define (error/500 request) void)