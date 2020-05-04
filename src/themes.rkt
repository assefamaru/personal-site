#lang racket

(require css-expr)

(provide dark-theme light-theme non-theme)

;; Dark theme styles.
(define dark-theme
  (css-expr->css
   (css-expr
    [body
     #:color |black|
     #:background-color |#22222A|]
    [.vline #:border-left |1px solid #353541|]
    [.hdrlink #:color |#BAC2C9|]
    [.sidebar
     [a #:color |#FFFFFF|]])))

;; Light theme styles.
(define light-theme
  (css-expr->css
   (css-expr
    [body
     #:color |#333|
     #:background-color |#F5F5F5|]
    [.vline #:border-left |1px solid #E0E0E0|]
    [.hdrlink #:color |#616161|]
    [.sidebar
     [a #:color |#616161|]])))

;; Non-theme styles.
(define non-theme
  (css-expr->css
   (css-expr
    [body
     #:margin 0
     #:padding 0
     #:height 200vh
     #:position relative
     #:font-family |"Source Sans Pro"|]
    [.vline
     #:height 100%
     #:position absolute
     #:top 0
     #:bottom 0
     #:z-index -1]
    [.vline1 #:left 50px]
    [.vline2 #:left 25%]
    [.vline3 #:left 50%]
    [.vline4 #:left 75%]
    [.vline5 #:right 50px]
    [.header
     #:width (- 100vw 100px)
     #:height 70px
     #:padding-left 50px
     [.hdrlink
      #:font-size 16px
      #:position absolute
      #:line-height 60px
      #:font-weight bold]
     [.hdrlink1 #:left 65px]
     [.hdrlink2 #:left 26%]
     [.hdrlink3 #:left 51%]
     [.hdrlink4 #:left 76%]]
    [.sidebar
     #:width 50px
     #:height 100vh
     #:position fixed
     #:z-index 100
     #:top 0
     #:bottom 0
     [.sidebar-content
      #:bottom 10
      #:position absolute
      [a
       #:width 50px
       #:height 50px
       #:display |block|
       #:text-align |center|
       [.fa #:line-height 50px]]]])))