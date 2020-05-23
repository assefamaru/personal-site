#lang racket/base

(require db)

(provide db-create!
         db-drop!
         db-destroy!
         db-insert-post!
         db-insert-draft!
         db-insert-comment!
         db-insert-category!
         db-insert-subscription!
         db-update-post!
         db-update-draft!
         db-update-category!
         db-update-subscription!
         db-delete-post!
         db-delete-draft!
         db-delete-comment!
         db-delete-category!
         db-delete-subscription!
         db-select-posts
         db-select-comments
         db-select-drafts
         db-select-categories
         db-select-subscriptions
         db-select-partial-posts
         db-select-category-posts
         db-select-post
         db-select-draft)

;; db-create! : db-conn -> void
;; Creates database with latest schema.
(define (db-create! db)
  (unless (table-exists? db "posts")
    (query-exec
     db
     "CREATE TABLE posts (
        id          INT AUTO_INCREMENT PRIMARY KEY,
        title       VARCHAR(255) NOT NULL,
        category    VARCHAR(255) NOT NULL,
        topics      VARCHAR(255),
        description VARCHAR(255) NOT NULL,
        body        TEXT         NOT NULL,
        created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) AUTO_INCREMENT=314159;"))
  (unless (table-exists? db "drafts")
    (query-exec
     db
     "CREATE TABLE drafts (
        id          INT AUTO_INCREMENT PRIMARY KEY,
        title       VARCHAR(255),
        category    VARCHAR(255),
        topics      VARCHAR(255),
        description VARCHAR(255),
        body        TEXT,
        created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) AUTO_INCREMENT=314159;"))
  (unless (table-exists? db "comments")
    (query-exec
     db
     "CREATE TABLE comments (
        id         INT AUTO_INCREMENT PRIMARY KEY,
        post_id    INT          NOT NULL,
        first_name VARCHAR(100) NOT NULL,
        last_name  VARCHAR(100) NOT NULL,
        email      VARCHAR(255),
        content    TEXT         NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX (post_id)
      );"))
  (unless (table-exists? db "categories")
    (query-exec
     db
     "CREATE TABLE categories (
        id         INT AUTO_INCREMENT PRIMARY KEY,
        category   VARCHAR(255)         NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE INDEX unique_category (category)
      );"))
  (unless (table-exists? db "subscriptions")
    (query-exec
     db
     "CREATE TABLE subscriptions (
        id         INT AUTO_INCREMENT PRIMARY KEY,
        email      VARCHAR(255)         NOT NULL,
        active     TINYINT(1) DEFAULT 1 NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE INDEX unique_email (email)
      );")))

;; db-drop! : db-conn string? -> void
;; Drops a single 'table' if present in database.
(define (db-drop! db table)
  (query-exec db (string-append "DROP TABLE IF EXISTS " table ";")))

;; db-destroy! : db-conn -> void
;; Drops all tables present in database.
(define (db-destroy! db)
  (db-drop! db "posts")
  (db-drop! db "drafts")
  (db-drop! db "comments")
  (db-drop! db "categories")
  (db-drop! db "subscriptions"))

;; Inserts =====================================================================

;; db-insert-post! : db-conn string? string? string? string? string? -> void
;; Consumes a db-conn and a post, and adds the post to the database.
(define (db-insert-post! db title category topics description body)
  (query-exec
   db
   "INSERT INTO posts (title,category,topics,description,body) VALUES(?,?,?,?,?);"
   title category topics description body))

;; db-insert-draft! : db-conn string? string? string? string? string? -> void
;; Consumes a db-conn and a draft, and adds the draft to the database.
(define (db-insert-draft! db title category topics description body)
  (query-exec
   db
   "INSERT INTO drafts (title,category,topics,description,body) VALUES(?,?,?,?,?);"
   title category topics description body))

;; db-insert-comment! : db-conn integer? string? string? string? string? -> void
;; Consumes a db-conn and a comment, and adds the comment to the database.
;; The comment belongs to the post whose id = post_id.
(define (db-insert-comment! db post-id first-name last-name email content)
  (query-exec
   db
   "INSERT INTO comments (post_id,first_name,last_name,email,content) VALUES(?,?,?,?,?);"
   post-id first-name last-name email content))

;; db-insert-category! : db-conn string? -> void
;; Consumes a db-conn and a category, and adds the category to database.
(define (db-insert-category! db category)
  (query-exec
   db
   "INSERT INTO categories (category) VALUES(?);"
   category))

;; db-insert-subscription! : db-conn string? -> void
;; Consumes a db-conn and a subscription, and adds that subscription to database.
(define (db-insert-subscription! db email)
  (query-exec
   db
   "INSERT INTO subscriptions (email) VALUES(?);"
   email))

;; Updates =====================================================================

;; db-update-post! : db-conn integer? string? string? string? string? string? -> void
;; Updates the different sections of a post after an edit is made.
(define (db-update-post! db id title category topics description body)
  (query-exec
   db
   "UPDATE posts SET title = ?, category = ?, topics = ?, description = ?, body = ? WHERE id = ?;"
   title category topics description body id))

;; db-update-draft! : db-conn integer string? string? string? string? string? -> void
;; Updates the different sections of a draft after an edit is made.
(define (db-update-draft! db id title category topics description body)
  (query-exec
   db
   "UPDATE drafts SET title = ?, category = ?, topics = ?, description = ?, body = ? WHERE id = ?;"
   title category topics description body id))

;; db-update-category! : db-conn integer? string? -> void
;; Updates a category field for the blog.
(define (db-update-category! db id category)
  (query-exec
   db
   "UPDATE categories SET category = ? WHERE id = ?;"
   category id))

;; db-update-subscription! : db-conn string? integer? -> void
;; Updates a subscription by setting its 'active' status to either 0 or 1.
(define (db-update-subscription! db email active)
  (query-exec
   db
   "UPDATE subscriptions SET active = ? WHERE email = ?;"
   active email))

;; Deletes =====================================================================

;; db-delete-post! : db-conn integer -> void
;; Deletes a blog post using its unique id.
(define (db-delete-post! db id)
  (query-exec
   db
   "DELETE FROM posts WHERE id = ?;"
   id))

;; db-delete-draft! : db-conn integer? -> void
;; Deletes a blog draft using its unique id.
(define (db-delete-draft! db id)
  (query-exec
   db
   "DELETE FROM drafts WHERE id = ?;"
   id))

;; db-delete-comment! : db-conn integer? -> void
;; Deletes a post comment using its unique id.
(define (db-delete-comment! db id)
  (query-exec
   db
   "DELETE FROM comments WHERE id = ?;"
   id))

;; db-delete-category! : db-conn string? -> void
;; Deletes a category using its unique name.
(define (db-delete-category! db category)
  (query-exec
   db
   "DELETE FROM categories WHERE category = ?;"
   category))

;; db-delete-subscription! : db-conn integer? -> void
;; Deletes a subscription using its unique email.
(define (db-delete-subscription! db email)
  (query-exec
   db
   "DELETE FROM subscriptions WHERE email = ?;"
   email))

;; Selects =====================================================================

;; db-select-posts : db-conn -> (listof vector?)
;; Selects all the posts currently in database.
(define (db-select-posts db)
  (query-rows
   db
   "SELECT id,title,category,topics,description,updated_at
    FROM posts ORDER BY updated_at DESC;"))

;; db-select-comments : db-conn integer? -> (listof vector?)
;; Selects all the comments for a particular post.
(define (db-select-comments db post-id)
  (query-rows
   db
   "SELECT first_name,last_name,email,content,created_at
    FROM comments WHERE post_id = ? ORDER BY created_at DESC;"
   post-id))

;; db-select-drafts : db-conn -> (listof vector?)
;; Selects all the drafts currently in database.
(define (db-select-drafts db)
  (query-rows
   db
   "SELECT id,title,category,topics,description,updated_at
    FROM drafts ORDER BY updated_at DESC;"))

;; db-select-categories : db-conn -> list?
;; Selects all the categories currently in database.
(define (db-select-categories db)
  (query-list
   db
   "SELECT category FROM categories;"))

;; db-select-subscriptions : db-conn [ boolean? ] -> list?
;; Selects the subscriptions currently in database.
;; 'active' has the following settings:
;; #t (default) : select all active subscriptions
;; #f           : select all inactive subscriptions
;; else         : select all subscriptions (active + inactive).
(define (db-select-subscriptions db [active #t])
  (cond
    (active (query-list db "SELECT email FROM subscriptions WHERE active = 1;"))
    ((not active) (query-list db "SELECT email FROM subscriptions WHERE active = 0;"))
    (else (query-list db "SELECT email FROM  subscriptions;"))))

;; db-select-partial-posts : db-conn -> (listof vector?)
;; Selects the 5 most recent posts under each category.
(define (db-select-partial-posts db)
  (define categories (db-select-categories db))
  (define (stmt categories)
    (cond
      ((null? categories)
       "SELECT id,title,category,topics,description,updated_at
        FROM posts ORDER BY updated_at DESC LIMIT 10;")
      ((null? (cdr categories))
       (string-append "SELECT id,title,category,topics,description,updated_at
                       FROM posts WHERE category = "
                      (car categories)
                      " ORDER BY updated_at DESC LIMIT 5;"))
      (else
       (string-append "SELECT id,title,category,topics,description,updated_at
                       FROM posts WHERE category = "
                      (car categories)
                      " ORDER BY created_at DESC LIMIT 5 UNION "
                      (stmt (cdr categories))))))
  (query-rows
   db
   (stmt categories)))

;; db-select-category-posts : db-conn string? -> (listof vector?)
;; Selects all posts in database under a particular category.
(define (db-select-category-posts db category)
  (query-rows
   db
   "SELECT id,title,topics,description,updated_at
    FROM posts WHERE category = ? ORDER BY updated_at DESC;"
   category))

;; db-select-post : db-conn integer? string? string? -> vector?
;; Retrieves a single post record using its id, title, and category.
(define (db-select-post db id title category)
  (query-row
   db
   "SELECT * FROM posts WHERE id = ? AND title = ? AND category = ?;"
   id title category))

;; db-select-draft : db-conn integer? -> vector?
;; Retrieves a single draft record using its id.
(define (db-select-draft db id)
  (query-row
   db
   "SELECT * FROM drafts WHERE id = ?;"
   id))