#lang racket/base

(require db
         "db.rkt")

(provide migrate!
         blog-insert-post!
         blog-insert-draft!
         post-insert-comment!
         blog-update-post!
         blog-update-draft!
         blog-delete-post!
         blog-delete-draft!
         post-delete-comment!)

;; migrate! : db-conn -> void
;; Recreates the database to its most current state.
(define (migrate! db)
  ; Create 'posts' table
  (unless (table-exists? db "posts")
    (query-exec
     db
     "CREATE TABLE posts (
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        title VARCHAR(255) NOT NULL,
        body TEXT NOT NULL,
        topics VARCHAR(255),
        created_at DEFAULT CURRENT_TIMESTAMP,
        updated_at DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) AUTO_INCREMENT=314159;"))
  ; Create 'drafts' table
  (unless (table-exists? db "drafts")
    (query-exec
     db
     "CREATE TABLE drafts (
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        title VARCHAR(255) NOT NULL,
        body TEXT,
        topics VARCHAR(255),
        created_at DEFAULT CURRENT_TIMESTAMP,
        updated_at DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) AUTO_INCREMENT=314159;"))
  ; Create 'comments' table
  (unless (table-exists? db "comments")
    (query-exec
     db
     "CREATE TABLE comments (
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        post_id INT NOT NULL,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        email VARCHAR(255),
        content TEXT NOT NULL,
        created_at DEFAULT CURRENT_TIMESTAMP,
        updated_at DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX post_id
      ) AUTO_INCREMENT=1;"))
  ; Create 'subscriptions' table
  (unless (table-exists? db "subscriptions")
    (query-exec
     db
     "CREATE TABLE subscriptions (
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        email VARCHAR(255) NOT NULL,
        active TINYINT(1) DEFAULT 1 NOT NULL,
        created_at DEFAULT CURRENT_TIMESTAMP,
        updated_at DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX email
      ) AUTO_INCREMENT=1;")))

;; blog-insert-post! : db-conn string? string? -> void
;; Consumes a db-conn and a post, and adds the post to the blog.
;; This also removes the draft copy of the post if it exists.
(define (blog-insert-post! db title body [draft-id #f])
  (query-exec
   db
   "INSERT INTO posts (title,body) VALUES(?,?);"
   title body)
  (unless (not draft-id)
    (query-exec
     db
     "DELETE FROM drafts WHERE id = ?;"
     draft-id)))

;; blog-insert-draft! : db-conn string? string? -> void
;; Consumes a db-conn and a draft, and adds the draft to the blog.
(define (blog-insert-draft! db title body)
  (query-exec
   db
   "INSERT INTO drafts (title,body) VALUES(?,?);"
   title body))

;; post-insert-comment! : db-conn integer? string? string? string? -> void
;; Consumes a db-conn, a post-id and a comment, and
;; adds the comment to the post with id = post-id.
(define (post-insert-comment! db post-id first-name last-name email)
  (query-exec
   db
   "INSERT INTO comments (post_id,first_name,last_name,email) VALUES(?,?,?,?);"
   post-id first-name last-name email))

;; blog-update-post! : db-conn string? string? integer? -> void
;; Updates the title and body of a post after an edit.
(define (blog-update-post! db title body post-id)
  (query-exec
   db
   "UPDATE posts SET title = ?, body = ? WHERE id = ?;"
   title body post-id))

;; blog-update-draft! : db-conn string? string? integer? -> void
;; Updates the title and body of a draft after an edit.
(define (blog-update-draft! db title body draft-id)
  (query-exec
   db
   "UPDATE drafts SET title = ?, body = ? WHERE id = ?;"
   title body draft-id))

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