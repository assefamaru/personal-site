#lang racket/base

(require db
         "db.rkt")

;; A blog is a (blog db)
;; where db is a mysql connection.
(struct blog (db))

;; A post is a (post blog id)
;; where blog is a blog and id is an integer?
(struct post (blog id))

;; initialize-blog! : void -> blog?
;; Creates tables for the blog (if any of them don't exist).
(define (initialize-blog!)
  (define the-blog (blog db-conn))
  ; Create posts table if not present
  (unless (table-exists? db-conn "posts")
    (query-exec
     db-conn
     "CREATE TABLE posts (
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        title VARCHAR(255) NOT NULL,
        body TEXT,
        created_at DEFAULT CURRENT_TIMESTAMP,
        updated_at DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) AUTO_INCREMENT=314159;"))
  ; Create comments table if not present
  (unless (table-exists? db-conn "comments")
    (query-exec
     db-conn
     "CREATE TABLE comments (
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        post_id INT NOT NULL,
        fname VARCHAR(100) NOT NULL,
        lname VARCHAR(100) NOT NULL,
        content TEXT,
        created_at DEFAULT CURRENT_TIMESTAMP,
        updated_at DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX post_id
      ) AUTO_INCREMENT=1;"))
  ; Create subscriptions table if not present
  (unless (table-exists? db-conn "subscriptions")
    (query-exec
     db-conn
     "CREATE TABLE subscriptions (
        id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
        email VARCHAR(255) NOT NULL,
        created_at DEFAULT CURRENT_TIMESTAMP,
        INDEX email
      ) AUTO_INCREMENT=1;"))
  the-blog)

;; blog-insert-post! : blog? string? string? -> void
;; Consumes a blog and a post, and adds the post to the blog.
(define (blog-insert-post! a-blog title body)
  (query-exec
   (blog-db a-blog)
   "INSERT INTO posts"
   title body))

;; post-insert-comment! : blog? post string? -> void
;; 
(define (post-insert-comment! a-blog a-post a-comment)
  (query-exec
   (blog-db a-blog)
   "INSERT INTO comments "
   (post-id a-post) a-comment))