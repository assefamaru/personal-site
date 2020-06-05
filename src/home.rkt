#lang racket/base

(require racket/string
         "render.rkt")

(provide home-path)

;; Handler for the root "/" home page.
(define (home-path request)
  (render/page request hero))

;; Hero section (home page).
(define (hero)
  `(section
    ((class "hero"))
    (h1 "hi!")
    (p "I'm "
       (strong "Alexander Maru")
       ", a student, programmer, and aspiring mathematician.")
    (p ,(string-normalize-spaces
         "I currently study mathematics at University of Waterloo, and do
          freelance work on the side. I enjoy working on side projects,
          and contributing to open-source software in my spare time."))
    (p ,(string-normalize-spaces
         "I'm interested in learning about, and working on a wide range of
          fields, including artificial intelligence, machine learning,
          cryptography, robotics, and pure math, to mention but a few."))
    (p "You can contact me via email at: "
       (strong "i@alexandermaru.com")
       " or through any of my social media accounts.")))