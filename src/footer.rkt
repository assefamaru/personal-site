#lang racket/base

(provide footer)

(define (footer)
  `(div ((class "footer"))
        (small
         "Copyright © 2015 — "
         (span ((id "year")))
         ", "
         (a ((href "https://alexandermaru.com"))
            "@assefamaru")
         ".")
        (script "document.getElementById(\"year\").innerHTML = new Date().getFullYear();")))