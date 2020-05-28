#lang racket/base

(require css-expr)

(provide dark-theme light-theme non-theme)

;; Dark theme styles.
(define dark-theme
  (css-expr->css
   (css-expr
    [body
     #:color |#BAC2C9|
     #:background-color |#22222A|
     [a #:color |#E91E63|]
     [strong #:color |#FFFFFF|]]
    [.vline #:border-left |1px solid #272731|]
    [.hdr-a #:color |#BAC2C9|]
    [.sidebar
     [a #:color |#FFFFFF|]]
    [.sidebar-right
     [a #:color |#FFFFFF|]]
    [.hero-h1 #:color |#FFFFFF|]
    [.posts-wrapper
     [a #:color |#BAC2C9|]]
    [.blog-form
     [.form-text
      #:color |#BAC2C9|
      #:border |1px solid #E91E63|
      #:background-color |#22222A|]])))

;; Light theme styles.
(define light-theme
  (css-expr->css
   (css-expr
    [body
     #:color |#616161|
     #:background-color |#FFFFFF|
     [a #:color |#E91E63|]]
    [.vline #:border-left |1px solid #E0E0E0|]
    [.vline2 #:display none]
    [.vline3 #:display none]
    [.vline4 #:display none]
    [.hdr-a #:color |#616161|]
    [.sidebar
     [a #:color |#616161|]]
    [.sidebar-right
     [a #:color |#616161|]]
    [.posts-wrapper
     [a #:color |#616161|]])))

;; Non-theme styles.
(define non-theme
  (css-expr->css
   (css-expr
    [body
     #:margin 0
     #:padding 0
     #:min-height 101vh
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
       [.hdr-a3 #:left 51%]
       [.hdr-a4 #:left 76%]]]]
    [.sidebar
     #:width 50px
     #:height 100vh
     #:position fixed
     #:z-index 100
     #:top 0
     #:bottom 0
     [a
      #:width 50px
      #:height 50px
      #:display |block|
      #:text-align |center|
      [.fa #:line-height 50px]]]
    [.sidebar-left
     [.sidebar-left-content
      #:position absolute
      #:bottom 0
      #:margin-bottom 10px]]
    [.sidebar-right
     #:right 0
     #:top 5px]
    [.spacer #:height 80px]
    [.footer
     #:position absolute
     #:bottom 0
     #:margin-bottom 35px
     #:left 76%
     #:font-weight bold]
    [.errors
     #:max-width 600px
     #:position absolute
     #:margin-top 28vh
     #:margin-right 15px
     #:left 26%
     [h1
      #:font-size 80px
      #:margin 0]]
    [.hero
     #:width 70%
     #:max-width 600px
     #:position relative
     #:margin-top 28vh
     #:margin-right 15px
     #:left 26%
     [.hero-h1
      #:font-size 80px
      #:margin 0]]
    [.blog-form
     #:width 70vw
     #:max-width 1000px
     #:margin-top 100px
     #:margin-left auto
     #:margin-right auto
     [.form-text
      #:display block
      #:width 100%
      #:margin-bottom 20px
      #:line-height 20px
      #:padding 10px
      #:font-size 16px
      #:font-weight 600
      #:font-family |"Source Sans Pro"|
      #:resize none]]
    [.posts-wrapper
     #:width 750px
     #:max-width 70%
     #:margin-top 100px
     #:position relative
     #:left 26%
     [.post-item
      #:text-decoration none
      #:display block
      #:margin-bottom 50px
      [h3
       #:color |#FFFFFF|
       #:font-size 25px
       #:margin 0]
      [p #:margin |10px 0 0 0|]]]
    [.post-topic
       #:color |#E91E63|
       #:border |1px solid #E91E63|
       #:margin-top 10px
       #:display inline-block
       #:margin-right 5px
       #:padding |0 3px|]
    [.blog-post
     #:width 750px
     #:max-width 70%
     #:margin-top 100px
     #:position relative
     #:left 26%
     [h1
      #:color |#FFFFFF|
      #:margin 0]
     [p
      #:margin-top 20px
      #:letter-spacing .5px
      #:line-height 25px]]
    [@media (and screen (#:max-width 700px))
            [.vline2 #:display none]
            [.vline4 #:display none]
            [.hdr-a2 #:left |53% !important|]
            [.hdr-a3
             #:left |53% !important|
             #:margin-top 30px]
            [.hdr-a4
             #:left |53% !important|
             #:margin-top 60px]
            [.footer #:left |65px !important|]
            [.errors
             #:left 65px
             #:margin-top 20vh]
            [.hero
             #:left 65px
             #:margin-top 18vh]
            [.blog-form
             #:margin-top 18vh]
            [.posts-wrapper
             #:left 65px
             #:margin-top 18vh]
            [.blog-post
             #:left 65px
             #:margin-top 18vh]])))