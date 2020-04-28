#lang racket

(require web-server/servlet)
(provide/contract (home (request? . -> . response?)))

(define (head title)
  `(head
    (meta ((charset "utf-8")))
    (meta ((name "viewport")
           (content "width=device-width, initial-scale=1")))
    (title ,title)
    (meta ((name "author")
           (content "@assefamaru")))
    (meta ((name "description")
           (content "Student, programmer, aspiring mathematician.")))
    (link ((rel "stylesheet")
           (type "text/css")
           (href "styles.css")))
    (link ((rel "stylesheet")
           (href "https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,700,900")))
    (script ((type "text/javascript")
             (src "main.js")))
    (script ((type "text/javascript")
             (src "https://use.fontawesome.com/78853d9834.js")))
    (script ((async "")
             (src "https://www.googletagmanager.com/gtag/js?id=UA-106749390-2")))
    ,(google-analytics)))

(define (google-analytics)
  `(script "window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', 'UA-106749390-2');"))

(define (home req)
  (response/xexpr
   `(html ,(head "Alexander Maru")
          (body
           (p "Hello, world!")))))