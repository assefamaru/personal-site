#lang racket/base

(require db)

(provide db-create!
         db-drop!
         db-destroy!
         db-insert-post!
         db-insert-draft!
         db-insert-comment!
         db-insert-subscription!
         db-update-post!
         db-update-draft!
         db-delete-post!
         db-delete-draft!
         db-delete-comment!
         db-delete-subscription!
         db-list-posts
         db-list-all-posts
         db-list-category-posts
         db-list-comments
         db-list-drafts)

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
        created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      ) AUTO_INCREMENT=314159;"))
  (unless (table-exists? db "drafts")
    (query-exec
     db
     "CREATE TABLE drafts (
        id          INT AUTO_INCREMENT PRIMARY KEY,
        title       VARCHAR(255) NOT NULL,
        category    VARCHAR(255) NOT NULL,
        topics      VARCHAR(255),
        description VARCHAR(255),
        body        TEXT,
        created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX (post_id)
      );"))
  (unless (table-exists? db "subscriptions")
    (query-exec
     db
     "CREATE TABLE subscriptions (
        id         INT AUTO_INCREMENT PRIMARY KEY,
        email      VARCHAR(255)         NOT NULL,
        active     TINYINT(1) DEFAULT 1 NOT NULL,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE INDEX unique_email (email)
      );")))

;; db-drop! : db-conn string? -> void
;; Drops a single 'table' if present in database.
(define (db-drop! db table)
  (query-exec db "DROP TABLE IF EXISTS ?;" table))

;; db-destroy! : db-conn -> void
;; Drops all tables present in database.
(define (db-destroy! db)
  (db-drop! db "posts")
  (db-drop! db "drafts")
  (db-drop! db "comments")
  (db-drop! db "subscriptions"))

(define (db-insert-post! db) void)
(define (db-insert-draft! db) void)
(define (db-insert-comment! db) void)
(define (db-insert-subscription! db) void)

(define (db-update-post! db) void)
(define (db-update-draft! db) void)

(define (db-delete-post! db) void)
(define (db-delete-draft! db) void)
(define (db-delete-comment! db) void)
(define (db-delete-subscription! db) void)

(define (db-list-posts db) void)          ;; 5 of each category
(define (db-list-all-posts db) void)      ;; all posts, in desc by upload date 
(define (db-list-category-posts db) void) ;; all category posts

(define (db-list-comments db) void)
(define (db-list-drafts db) void)