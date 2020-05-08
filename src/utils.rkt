#lang racket/base

(require racket/string)

(provide string-clean)

(define (string-clean str)
  (apply string-append
         (string-split str "\n")))