#lang racket/base

(require racket/string)

(provide string-clean)

(define (string-clean str)
  (apply string-append
         (map string-trim
              (string-split str "\n"))))