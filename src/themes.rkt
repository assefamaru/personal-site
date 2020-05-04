#lang racket

(require css-expr
         web-server/servlet)

(provide dark-theme light-theme non-theme)

;; Dark theme styles.
(define dark-theme
  (css-expr->css
   (css-expr
    [body
     #:color |black|
     #:background-color |#22222A|]
    [.vline #:border-left |1px solid #353541|]
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
    [.sidebar
     #:width 50px
     #:height 100vh
     #:position fixed
     #:z-index 100
     [.sidebar-content
      #:bottom 10
      #:position |absolute|
      [a
       #:width 50px
       #:height 50px
       #:display |block|
       #:text-align |center|
       [.fa #:line-height 50px]]]]
                       

    )))