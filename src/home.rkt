#lang racket

(require "meta.rkt"
         "header.rkt"
         "sidebar.rkt"
         web-server/servlet)

(provide/contract (root-path (request? . -> . response?)))

(define (root-path request)
  (response/xexpr
   `(html ,(meta)
          (body
           ,(vertical-lines)
           ,(menu)
           ,(sidebar)
           ,(sidebar-right)
           ,(hero)))))

(define (hero)
  `(div ((class "hero"))
        (h1 ((class "hero-h1"))
            "hi!")
        (p ((class "hero-p"))
           "I'm "
           (strong "Alexander Maru")
           ", a software developer in Waterloo, Canada.")
        (p ((class "hero-p"))
           "I currently study mathematics and computer science at University of Waterloo,
            and do freelance work on the side. I enjoy working on side projects, and
            contributing to open-source software in my spare time.")
        (p ((class "hero-p"))
           "I'm interested in learning about, and working on a wide range of fields,
            including artificial intelligence, machine learning, cryptography, robotics,
            and pure math, to mention but a few.")
        (p ((class "hero-p"))
           "You can contact me via email at: "
           (strong "i@alexandermaru.com")
           " or through any of my social media accounts.")))