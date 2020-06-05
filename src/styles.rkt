#lang racket/base

(require css-expr)

(provide non-theme
         dark-theme
         light-theme)

;; Non-theme core styles.
(define non-theme
  (css-expr->css
   (css-expr
    [body #:margin 0
          #:padding 0
          #:width 100%
          #:height 100%
          #:min-height 100vh
          #:position relative
          #:font-family "Source Sans Pro"]
    [header #:width 100%
            #:height 50px
            #:padding-top 20px
            [a #:position absolute
               #:font-weight bold]
            [.hdr-a1 #:left 50px]
            [.hdr-a2 #:left 30%]
            [.hdr-a3 #:left 60%]
            [.hdr-a4 #:left 90%]]
    [.sidebar #:width 50px
              #:height 100vh
              #:position fixed
              #:z-index 100
              #:top 0
              #:bottom 0
              [a #:width 50px
                 #:height 50px
                 #:display block
                 #:text-align center
                 [.fa #:line-height 50px]]]
    [.sidebar-left
     [.sidebar-content #:position absolute
                            #:bottom 0
                            #:margin-bottom 10px]]
    [.sidebar-right #:right 0
                    [.sidebar-content #:margin-top 7.5px]]
    [.content-wrapper #:width |calc(100% - 100px)|
                      #:margin-left 50px
                      #:margin-bottom 50px
                      [.hero #:width 100%
                             #:max-width 600px
                             #:position relative
                             #:margin-top 25vh
                             #:left |calc(30% - 20px)|
                             [h1 #:font-size 80px
                                 #:margin 0
                                 #:padding 0]]]
    [.spacer-y #:height 50px]
    [footer #:position absolute
            #:left 76%
            #:bottom 25px
            #:font-weight bold]
    [@media (and screen (#:max-width 700px))
            [header #:height 100px
                    [.hdr-a2 #:left |50% !important|]
                    [.hdr-a3 #:left |50% !important|
                             #:margin-top |30px !important|]
                    [.hdr-a4 #:left |50% !important|
                             #:margin-top |60px !important|]]
            [.content-wrapper
             [.hero #:left 0
                    #:margin-top 10vh]]
            [footer #:left 50px]])))

;; Dark theme styles.
(define dark-theme
  (css-expr->css
   (css-expr
    [body #:color |#BAC2C9|
          #:background-color |#22222A|
     [a #:color |#E91E63|]
     [strong #:color |#FFFFFF|]]
    [header
     [a #:color |#BAC2C9|]]
    [.sidebar
     [a #:color |#BAC2C9|]]
    [.hero
     [h1 #:color |#FFFFFF|]])))

;; Light theme styles.
(define light-theme
  (css-expr->css
   (css-expr
    [body #:color |#616161|
          #:background-color |#FFFFFF|
     [a #:color |#E91E63|]])))