#lang racket/base

(require racket/string)

(provide string-clean)

;; string-clean: string? -> string?
;; Consumes a string and produces the same string
;; without any newlines '\n', and extra whitespaces
;; trimmed.
(define (string-clean str)
  (string-join
   (map string-trim (string-split str "\n"))))