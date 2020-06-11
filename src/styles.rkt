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
                                 #:padding 0]]
                      [.login #:width 100%
                              #:max-width 600px
                              #:position relative
                              #:margin-top 15vh
                              #:left |calc(30% - 20px)|
                              [form #:width 100%
                                    [.login-input #:display block
                                                  #:border none
                                                  #:outline none
                                                  #:width 100%
                                                  #:margin-bottom 30px
                                                  #:padding |3px 10px|]
                                    [input #:background-color transparent
                                           #:font-family "Source Sans Pro"
                                           #:font-size 16px]]]
                      [.posts-wrapper #:width 100%
                                      #:max-width 650px
                                      #:left |calc(30% - 20px)|
                                      #:position relative
                                      #:margin-top 50px
                                      [.post-item #:text-decoration none
                                                  #:display block
                                                  #:margin-bottom 50px
                                                  [h1 #:margin 0
                                                      #:font-size 22px]
                                                  [p #:margin |10px 0 0 0|]]]
                      [.blog-post #:position relative
                                  #:max-width 650px
                                  #:left |calc(30% - 20px)|
                                  #:margin-top 50px
                                  [h1 #:margin 0]]
                      [.post-topic #:margin-top 10px
                                   #:display inline-block
                                   #:margin-right 5px
                                   #:padding |0 3px|]
                      [.comments-section #:position relative
                                         #:width 100%
                                         #:margin-top 100px
                                         [form #:width 100%
                                               [textarea #:display block
                                                         #:border none
                                                         #:outline none
                                                         #:width 100%
                                                         #:resize vertical
                                                         #:margin-bottom 10px
                                                         #:padding |3px 10px|
                                                         #:background-color transparent
                                                         #:font-family "Source Sans Pro"
                                                         #:font-size 16px]
                                               [input #:background-color transparent
                                                      #:font-family "Source Sans Pro"
                                                      #:font-size 16px]]
                                         [.comments-list #:margin-top 50px
                                                         [.comment-item #:margin-bottom 50px
                                                                        [img #:width 35px
                                                                             #:height 35px
                                                                             #:border-radius 35px
                                                                             #:float left]
                                                                        [h4 #:margin 0
                                                                            #:margin-left 50px]
                                                                        [span #:margin 0
                                                                              #:display block
                                                                              #:margin-left 50px]
                                                                        [p #:margin-left 50px]]]]]
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
                    #:margin-top 10vh]
             [.login #:left 0]
             [.posts-wrapper #:left 0]
             [.blog-post #:left 0]]
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
     [h1 #:color |#FFFFFF|]]
    [.login
     [form
      [.login-input #:color |#BAC2C9|
                    #:border-left |2px solid #64FFDA !important|]
      [::placeholder #:color |#BAC2C9|
                     #:filter |brightness(80%)|]
      [.submit #:color |#64FFDA|
               #:border |1px solid #64FFDA|]]]
    [.posts-wrapper
     [.post-item #:color |#BAC2C9|
                 [h1 #:color |#FFFFFF|]]]
    [.blog-post
     [h1 #:color |#FFFFFF|]]
    [.post-topic #:color |#E91E63|
                 #:border |1px solid #E91E63|]
    [.comments-section
     [form
      [textarea #:color |#BAC2C9|
                #:border-left |2px solid #64FFDA !important|]
      [::placeholder #:color |#BAC2C9|
                     #:filter |brightness(80%)|]
      [input #:background-color transparent
             #:color |#64FFDA|
             #:border |1px solid #64FFDA|]]])))

;; Light theme styles.
(define light-theme
  (css-expr->css
   (css-expr
    [body #:color |#616161|
          #:background-color |#FFFFFF|
     [a #:color |#E91E63|]])))