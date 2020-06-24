#lang racket/base

(require web-server/http/redirect
         web-server/formlets
         web-server/http/request-structs
         net/url
         "auth.rkt"
         "db.rkt"
         "render.rkt"
         "model.rkt"
         "utils.rkt"
         "errors.rkt")

(provide login-path
         private-dispatch)

;; Login formlet.
(define new-login-formlet
  (formlet
   (#%# ,((to-string
           (required
            (text-input
             #:attributes '((class "login-input")
                            (placeholder "User")
                            (autocomplete "off")
                            (required "")
                            (autofocus "")))))
          . => . email)
        ,((to-string
           (required
            (password-input
             #:attributes '((class "login-input")
                            (placeholder "Pass")
                            (autocomplete "off")
                            (required "")))))
          . => . password))
   (values email password)))

;; Handler for the "/login" path.
(define (login-path request)
  (define (login-handler request)
    (define-values (email password)
      (formlet-process new-login-formlet request))
    (if (and (equal? email admin-user)
             (equal? password admin-pass))
        (redirect-to "/dashboard" see-other)
        (redirect-to "/login" see-other)))
  (if (bytes=? (request-method request) #"POST")
      (login-handler request)
      (render/page request
                   #:title "Log In"
                   (λ ()
                     `(div ((class "login"))
                           (form ((action ,(url->string (request-uri request)))
                                  (method "post"))
                                 ,@(formlet-display new-login-formlet)
                                 (input ((type "submit")
                                         (class "submit")))))))))

;; private-dispatch routes authenticated URLs to
;; corresponding private handler methods.
(define (private-dispatch request . args)
  (define len (length args))
  (cond
    [(not (authenticated? request))
     (redirect-to "/login" see-other)]
    [(= len 0)
        (dashboard-path request)]
    [(and (= len 1)
          (equal? (car args) "drafts"))
     (list-drafts request)]
    [(and (= len 2)
          (equal? (car args) "db")
          (equal? (cadr args) "create"))
     (create-db request)]
    [(and (= len 2)
          (equal? (car args) "db")
          (equal? (cadr args) "migrate"))
     (migrate-db request)]
    [(and (= len 2)
          (equal? (car args) "db")
          (equal? (cadr args) "drop"))
     (destroy-db request)]
    [(and (= len 2)
          (equal? (car args) "posts")
          (equal? (cadr args) "create"))
     (create-post request)]
    [(and (= len 2)
          (equal? (car args) "drafts")
          (number? (cadr args)))
     (edit-draft request (cadr args))]
    [(and (= len 3)
          (equal? (car args) "drafts")
          (number? (cadr args))
          (equal? (caddr args) "view"))
     (review-draft request (cadr args))]
    [else
     (error/404 request)]))

;; Handler for the "/dashboard" path.
(define (dashboard-path request)
  (render/page request
               #:title "Dashboard"
               (λ ()
                 `(div ((class "dashboard"))
                       (h3 "Blog Post")
                       (ul (li (a ((href "/dashboard/posts/create"))
                                  "Create Post"))
                           (li (a ((href "/dashboard/drafts"))
                                  "List Drafts")))
                       (h3 "Database")
                       (ul (li (a ((href "/dashboard/db/create"))
                                  "Create DB"))
                           (li (a ((href "/dashboard/db/migrate"))
                                  "Migrate DB"))
                           (li (a ((href "/dashboard/db/drop"))
                                  "Drop DB")))))))

;; Handler for the "/dashboard/drafts" path.
(define (list-drafts request)
  (define drafts (db-select-drafts db-conn))
  (if (null? drafts)
      (error/404 request
                 #:title "404 (Not Found)"
                 #:message "No drafts found in database.")
      (render/page request
                   #:title "Blog Drafts"
                   #:params drafts
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
                 `(a ((href ,(string-append "/dashboard/drafts/" id "/view"))
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

;; create-db : request? -> response
(define (create-db request)
  (db-create! db-conn)
  (success/200 request
               #:message "Yayy! Database has been successfully created."))

;; migrate-db : request? -> response
(define (migrate-db request)
  (db-migrate! db-conn)
  (success/200 request
               #:message "Yayy! Database has been successfully migrated."))

;; destroy-db : request? -> response
(define (destroy-db request)
  (db-destroy! db-conn)
  (success/200 request
               #:message "Yayy! Database has been successfully destroyed."))

;; New post formlet.
(define new-post-formlet
  (formlet
   (#%# ,((to-string
           (required
            (textarea-input
             #:rows 1
             #:attributes '((placeholder "Title")
                            (autocomplete "off")
                            (required "")))))
          . => . title)
        ,((to-string
           (required
            (textarea-input
             #:rows 1
             #:attributes '((placeholder "Category")
                            (autocomplete "off")
                            (required "")))))
          . => . category)
        ,((to-string
           (required
            (textarea-input
             #:rows 1
             #:attributes '((placeholder "Topics")
                            (autocomplete "off")))))
          . => . topics)
        ,((to-string
           (required
            (textarea-input
             #:rows 1
             #:attributes '((placeholder "Draft")
                            (autocomplete "off")))))
          . => . draft)
        ,((to-string
           (required
            (textarea-input
             #:rows 30
             #:attributes '((placeholder "Body")
                            (autocomplete "off")
                            (required "")))))
          . => . body))
   (values title category topics draft body)))

;; create-post : creates a new post (or draft of post) in db.
(define (create-post request)
  (define (insert-post-handler request)
    (define-values (title category topics draft body)
      (formlet-process new-post-formlet request))
    (db-insert-post! db-conn title category topics body
                                 (if (equal? (string-downcase draft) "yes") 1 0))
    (if (equal? (string-downcase draft) "yes")
        (redirect-to "/dashboard/drafts" see-other)
        (redirect-to "/blog" see-other)))
  (if (bytes=? (request-method request) #"POST")
      (insert-post-handler request)
      (render/page request
                   (λ ()
                     `(section
                       ((class "private-form"))
                       (form ((action ,(url->string (request-uri request)))
                              (method "post"))
                             ,@(formlet-display new-post-formlet)
                             (input ((type "submit")))))))))

;; Edit post formlet.
(define (edit-post-formlet old-title
                           old-category
                           old-topics
                           old-draft
                           old-body)
  (formlet
   (#%# ,((to-string
           (required
            (textarea-input
             #:value old-title
             #:rows 1
             #:attributes '((placeholder "Title")
                            (autocomplete "off")
                            (required "")))))
          . => . title)
        ,((to-string
           (required
            (textarea-input
             #:value old-category
             #:rows 1
             #:attributes '((placeholder "Category")
                            (autocomplete "off")
                            (required "")))))
          . => . category)
        ,((to-string
           (required
            (textarea-input
             #:value old-topics
             #:rows 1
             #:attributes '((placeholder "Topics")
                            (autocomplete "off")))))
          . => . topics)
        ,((to-string
           (required
            (textarea-input
             #:value (if (= old-draft 1) "yes" "no")
             #:rows 1
             #:attributes '((placeholder "Draft")
                            (autocomplete "off")))))
          . => . draft)
        ,((to-string
           (required
            (textarea-input
             #:value old-body
             #:rows 30
             #:attributes '((placeholder "Body")
                            (autocomplete "off")
                            (required "")))))
          . => . body))
   (values title category topics draft body)))

;; Handler for the "/dashboard/drafts/{id}" path.
(define (edit-draft request post-id)
  (define (update-post-handler request)
    (define-values (title category topics draft body)
      (formlet-process new-post-formlet request))
    (db-update-post! db-conn post-id title category topics body
                     (if (equal? (string-downcase draft) "yes") 1 0))
    (if (equal? (string-downcase draft) "yes")
        (redirect-to "/dashboard/drafts/" see-other)
        (redirect-to "/blog" see-other)))
  (cond
    [(bytes=? (request-method request) #"POST")
     (update-post-handler request)]
    [else
     (define post (db-select-draft db-conn post-id))
     (cond
       [(not post)
        (error/404 request
                   #:title "404 (Not Found)"
                   #:message "Post not found. Go back to home page.")]
       [else
        (define-values (title category topics draft body)
          (values (vector-ref post 1)
                  (vector-ref post 2)
                  (vector-ref post 3)
                  (vector-ref post 5)
                  (vector-ref post 6)))
        (render/page request
                     (λ ()
                       `(section
                         ((class "private-form"))
                         (form ((action ,(url->string (request-uri request)))
                                (method "post"))
                               ,@(formlet-display
                                  (edit-post-formlet title category topics draft body))
                               (input ((type "submit")))))))])]))

;; Handler for the "/dashboard/drafts/{id}/view" path.
(define (review-draft request post-id)
  (define post (db-select-draft db-conn post-id))
  (cond
    [(not post)
     (error/404 request
                #:title "404 (Not Found)"
                #:message "Post not found. Go back to home page.")]
    [else
     (define-values (id title category topics description body created-at)
       (values (number->string (vector-ref post 0))
               (vector-ref post 1)
               (vector-ref post 2)
               (vector-ref post 3)
               (vector-ref post 4)
               (vector-ref post 6)
               (parse/timestamp (vector-ref post 7))))
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
                          (div
                           (a ((class "edit-btn")
                               (href ,(string-append "/dashboard/drafts/" id)))
                              "Edit Draft")))))]))