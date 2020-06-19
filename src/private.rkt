#lang racket/base

(require web-server/http/redirect
         web-server/formlets
         web-server/http/request-structs
         net/url
         "auth.rkt"
         "db.rkt"
         "render.rkt"
         "model.rkt"
         "errors.rkt")

(provide private-dispatch)

;; private-dispatch routes authenticated URLs to
;; corresponding handler methods.
(define (private-dispatch request . args)
  (define len (length args))
  (cond
    [(authenticated? request)
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

;; create-post : request -> ...
(define (create-post request)
  (define (insert-post-handler request)
    (define-values (title category topics draft body)
      (formlet-process new-post-formlet request))
    (db-insert-post! db-conn title category topics body
                     (if (equal? draft "yes") 1 0))
    (redirect-to (string-append "/blog" category) see-other))
  (if (bytes=? (request-method request) #"POST")
      (insert-post-handler request)
      void)
  (render/page request
               (λ ()
                 `(section
                   ((class "private-form"))
                   (form ((action ,(url->string (request-uri request)))
                          (method "post"))
                         ,@(formlet-display new-post-formlet)
                         (input ((type "submit"))))))))

;; Handler for the "/dashboard/drafts/{id}" path.
(define (edit-draft request post-id)
  (render/page request
               (lambda ()
                 `(div "Edit post"))))

;; Handler for the "/dashboard/drafts" path.
(define (list-drafts request)
  (define drafts (db-select-drafts db-conn))
  (render/page request
               (lambda ()
                 `(div "List drafts"))))