#lang racket/base

(require racket/vector
         web-server/formlets
         web-server/http/redirect
         web-server/http/request-structs
         net/url
         "auth.rkt"
         "db.rkt"
         "model.rkt"
         "render.rkt"
         "status.rkt"
         "utils.rkt")

(provide blog-path
         list-posts
         review-post)

;; Handler for the "/blog" path.
(define (blog-path request)
  (define posts (db-select-partial-posts db-conn))
  (if (null? posts)
      (error/404 request
                 #:title "404 (Not Found)"
                 #:message "No posts found in database.")
      (render/page request
                   #:title "Blog"
                   #:params posts
                   blog-posts)))

;; Handler for the "/blog/{category}" path.
(define (list-posts request category)
  (define posts (db-select-category-posts db-conn category))
  (if (null? posts)
      (error/404 request
                 #:title "404 (Not Found)"
                 #:message "No posts found in database for this category.")
      (render/page request
                   #:title "Blog posts"
                   #:params posts
                   blog-posts)))

;; blog-posts : (listof vector) -> xexpr
(define (blog-posts posts)
  `(div ((class "posts-wrapper"))
        ,@(map (λ (post)
                 (define-values
                   (id title url-title category topics description created-at)
                   (values (number->string (vector-ref post 0))
                           (vector-ref post 1)
                           (vector-ref post 2)
                           (vector-ref post 3)
                           (vector-ref post 4)
                           (vector-ref post 5)
                           (parse/timestamp (vector-ref post 6))))
                 `(a ((href ,(string-append "/blog/" category "/" id "/" url-title))
                      (class "post-item"))
                     (div (h1 ,title)
                          (small ,created-at)
                          (small " • " ,category)
                          (br)
                          ,(if (equal? topics "")
                               `(span)
                               `(div ,@(map (λ (topic)
                                              `(small ((class "post-topic"))
                                                      ,topic))
                                            (string-split topics))))
                          (p ,description "..."))))
               posts)))

;; New comment formlet.
(define new-comment-formlet
  (formlet
   (#%# ,((to-string
           (required
            (textarea-input
             #:rows 1
             #:attributes '((placeholder "First Name")
                            (autocomplete "off")
                            (required "")))))
          . => . first-name)
        ,((to-string
           (required
            (textarea-input
             #:rows 1
             #:attributes '((placeholder "Last Name")
                            (autocomplete "off")
                            (required "")))))
          . => . last-name)
        ,((to-string
           (required
            (textarea-input
             #:rows 1
             #:attributes '((placeholder "Email")
                            (autocomplete "off")))))
          . => . email)
        ,((to-string
           (required
            (textarea-input
             #:rows 5
             #:attributes '((placeholder "Join the discussion ...")
                            (autocomplete "off")
                            (required "")))))
          . => . content))
   (values first-name last-name email content)))

;; Handler for the "/blog/{category}/{id}/{title}" path.
(define (review-post request category id url-title)
  (define post (db-select-post db-conn id url-title category))
  (cond
    ((not post)
     (error/404 request
                #:title "404 (Not Found)"
                #:message "Post not found. Go back to home page."))
    (else
     (define-values (post-id title topics description body created-at)
       (values (vector-ref post 0)
               (vector-ref post 1)
               (vector-ref post 4)
               (vector-ref post 5)
               (vector-ref post 6)
               (parse/timestamp (vector-ref post 7))))
     (define (insert-comment-handler request)
       (define-values (first-name last-name email content)
         (formlet-process new-comment-formlet request))
       (db-insert-comment! db-conn post-id first-name last-name email content)
       (redirect-to (url->string (request-uri request)) see-other))
     (if (bytes=? (request-method request) #"POST")
         (insert-comment-handler request)
         void)
     (define comments (db-select-comments db-conn post-id))
     (render/page request
                  #:title title
                  #:description (string-append description "...")
                  (λ ()
                    `(div ((class "blog-post"))
                          (h1 ,title)
                          (small ,created-at)
                          (small " • " ,category)
                          (small " • " ,(reading-time body) " min read")
                          (br)
                          ,(if (equal? topics "")
                               `(span)
                               `(div
                                 ,@(map (λ (topic)
                                          `(small ((class "post-topic"))
                                                  ,topic))
                                        (string-split topics))))
                          ,@(map (λ (x)
                                   `(p ((class "blog-body-p")) ,x))
                                 (string-split body "\n"))
                          (section
                           ((class "comments-section"))
                           (h4 ((class "comments-count"))
                               ,(pluralize (length comments) "Comment"))
                           (form ((action ,(url->string (request-uri request)))
                                  (method "post"))
                                 ,@(formlet-display new-comment-formlet)
                                 (input ((type "submit"))))
                           (div ((class "comments-list"))
                                ,@(map (λ (comment)
                                         (define-values
                                           (first-name last-name email content created-at)
                                           (values (vector-ref comment 0)
                                                   (vector-ref comment 1)
                                                   (vector-ref comment 2)
                                                   (vector-ref comment 3)
                                                   (vector-ref comment 4)))
                                         `(div ((class "comment-item"))
                                               (img ((src ,(gravatar-url email))))
                                               (h4 ,(string-append first-name " " last-name))
                                               (span
                                                (small,(parse/timestamp created-at)))
                                               ,@(map (λ (x)
                                                        `(p ((class "comment-p")) ,x))
                                                      (string-split content "\n"))))
                                       comments)))))))))