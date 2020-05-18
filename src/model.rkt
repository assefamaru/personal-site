#lang racket/base

(require db)

(provide update-db!
         blog-insert-post!
         blog-insert-draft!
         post-insert-comment!
         blog-update-post!
         blog-update-draft!
         blog-delete-post!
         blog-delete-draft!
         post-delete-comment!
         blog-categorized-posts
         blog-list-posts
         blog-list-drafts
         blog-retrieve-post
         blog-retrieve-draft)

;; update-db! : db-conn -> void
;; Recreates the database to its most current state.
(define (update-db! db)
  ; Create 'posts' table
  (unless (table-exists? db "posts")
    (query-exec
     db
     "CREATE TABLE posts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        body TEXT NOT NULL,
        category VARCHAR(255) NOT NULL,
        description VARCHAR(255) NOT NULL,
        topics VARCHAR(255),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) AUTO_INCREMENT=314159;"))
  ; Create 'drafts' table
  (unless (table-exists? db "drafts")
    (query-exec
     db
     "CREATE TABLE drafts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        body TEXT,
        category VARCHAR(255) NOT NULL,
        description VARCHAR(255),
        topics VARCHAR(255),
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) AUTO_INCREMENT=314159;"))
  ; Create 'comments' table
  (unless (table-exists? db "comments")
    (query-exec
     db
     "CREATE TABLE comments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        post_id INT NOT NULL,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        email VARCHAR(255),
        content TEXT NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX (post_id)
      );"))
  ; Create 'subscriptions' table
  (unless (table-exists? db "subscriptions")
    (query-exec
     db
     "CREATE TABLE subscriptions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        email VARCHAR(255) NOT NULL,
        active TINYINT(1) DEFAULT 1 NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE INDEX unique_email (email)
      );")))

;; blog-insert-post! : db-conn string? string? string? string? string? -> void
;; Consumes a db-conn and a post, and adds the post to the blog.
;; This also removes the draft copy of the post if it exists.
(define (blog-insert-post! db title body category description topics [draft-id #f])
  (query-exec
   db
   "INSERT INTO posts (title,body,category,description,topics) VALUES(?,?,?,?,?);"
   title body category description topics)
  (unless (not draft-id)
    (query-exec
     db
     "DELETE FROM drafts WHERE id = ?;"
     draft-id)))

;; blog-insert-draft! : db-conn string? string? string? string? string? -> void
;; Consumes a db-conn and a draft, and adds the draft to the blog.
(define (blog-insert-draft! db title body category description topics)
  (query-exec
   db
   "INSERT INTO drafts (title,body,category,description,topics) VALUES(?,?,?,?);"
   title body category description topics))

;; post-insert-comment! : db-conn integer? string? string? string? -> void
;; Consumes a db-conn, a post-id and a comment, and
;; adds the comment to the post with id = post-id.
(define (post-insert-comment! db post-id first-name last-name email)
  (query-exec
   db
   "INSERT INTO comments (post_id,first_name,last_name,email) VALUES(?,?,?,?);"
   post-id first-name last-name email))

;; blog-update-post! : db-conn string? string? string? string? string? integer? -> void
;; Updates the title and body of a post after an edit.
(define (blog-update-post! db title body category description topics post-id)
  (query-exec
   db
   "UPDATE posts SET title = ?, body = ?, category = ?, description = ?, topics = ? WHERE id = ?;"
   title body category description topics post-id))

;; blog-update-draft! : db-conn string? string? string? string? string? integer? -> void
;; Updates the title and body of a draft after an edit.
(define (blog-update-draft! db title body category description topics draft-id)
  (query-exec
   db
   "UPDATE drafts SET title = ?, body = ?, category = ?, topics = ? WHERE id = ?;"
   title body category description topics draft-id))

;; blog-delete-post! : db-conn integer? -> void
;; Deletes a blog post using its post-id.
(define (blog-delete-post! db post-id)
  (query-exec
   db
   "DELETE FROM posts WHERE id = ?;"
   post-id))

;; blog-delete-draft! : db-conn integer? -> void
;; Deletes a draft copy using its draft-id.
(define (blog-delete-draft! db draft-id)
  (query-exec
   db
   "DELETE FROM drafts WHERE id = ?;"
   draft-id))

;; post-delete-comment! : db-conn integer? -> void
;; Deletes a comment from a post using its comment-id.
(define (post-delete-comment! db comment-id)
  (query-exec
   db
   "DELETE FROM comments WHERE id = ?;"
   comment-id))

;; blog-categorized-posts : db-conn -> list-of-posts
;; Retrieves a list of categorized posts in blog.
(define (blog-categorized-posts db)
  (query-rows
   db
   "SELECT category, title, description, updated_at FROM posts GROUP BY category LIMIT 10;"))

;; blog-list-posts : db-conn -> list-of-posts
;; Retrieves a list of all the posts in blog.
(define (blog-list-posts db)
  (query-rows
   db
   "SELECT category, title, description, updated_at FROM posts ORDER BY created_at DESC;"))

;; blog-list-drafts : db-conn -> list-of-drafts
;; Retrieves a list of all the drafts in blog.
(define (blog-list-drafts db)
  (query-rows
   db
   "SELECT category, title, description, updated_at FROM drafts ORDER BY created_at DESC;"))

;; blog-retrieve-post : db-conn integer? string? string? -> a-post
;; Retrieves a single blog post using its category, post-id, and title.
(define (blog-retrieve-post db post-id title category)
  (query-row
   db
   "SELECT * FROM posts WHERE id = ? AND title = ? AND category = ?;"
   post-id title category))

;; blog-retrieve-draft : db-conn integer? string? string? -> a-draft
;; Retrieves a single blog draft using its category, draft-id, and title.
(define (blog-retrieve-draft db draft-id title category)
  (query-row
   db
   "SELECT * FROM drafts WHERE id = ? AND title = ? AND category = ?;"
   draft-id title category))