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
    [.hdr-a #:color |#BAC2C9|]
    [.sidebar
     [a #:color |#FFFFFF|]]
    [.sidebar-right
     [a #:color |#FFFFFF|]]
    [.hero
     [strong #:color |#FFFFFF|]]
    [.hero-h1 #:color |#FFFFFF|]
    [.hero-p #:color |#BAC2C9|])))

;; Light theme styles.
(define light-theme
  (css-expr->css
   (css-expr
    [body
     #:color |#333|
     #:background-color |#F5F5F5|]
    [.vline #:border-left |1px solid #E0E0E0|]
    [.hdr-a #:color |#616161|]
    [.sidebar
     [a #:color |#616161|]]
    [.sidebar-right
     [a #:color |#616161|]]
    [.hero
     [strong #:color |#616161|]]
    [.hero-h1 #:color |#616161|]
    [.hero-p #:color |#616161|])))

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
     #:padding-top 20px
     #:padding-left 50px
     [.hdr-ul
      #:display inline-block
      #:margin 0
      #:vertical-align top
      [.hdr-li
       #:display block
       [.hdr-a
        #:position absolute
        #:font-size 16px
        #:font-weight bold]
       [.hdr-a1 #:left 65px]
       [.hdr-a2 #:left 26%]
       [.hdr-a3
        #:left 26%
        #:margin-top 30px]]]]
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
       [.fa #:line-height 50px]]]]
    [.sidebar-right
     #:right 0
     [.sidebar-right-content
      #:top 8
      #:position absolute
      [a
       #:width 50px
       #:height 50px
       #:display |block|
       #:text-align |center|
       [.fa #:line-height 50px]]]]
    [.hero
     #:max-width 600px
     #:position absolute
     #:margin-top 30vh
     #:margin-right 15px
     #:left 26%
     [.hero-h1
      #:font-size 80px
      #:margin 0]]
    [@media (and screen (#:max-width 700px))
            [.vline2 #:display none]
            [.vline4 #:display none]
            [.hdr-a2 #:left |53% !important|]
            [.hdr-a3 #:left |53% !important|]
            [.hero
             #:left 65px
             #:margin-top 15vh]])))