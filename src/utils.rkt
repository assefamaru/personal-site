#lang racket/base

(require racket/string)

(provide string-clean)

;; string-clean: string? -> string?
;; Consumes a string and produces the same string
;; without any newlines '\n'.
(define (string-clean str)
  (apply string-append
         (string-split str "\n")))