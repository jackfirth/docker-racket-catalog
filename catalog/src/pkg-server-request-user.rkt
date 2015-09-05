#lang racket

(require web-server/http/request-structs
         fancy-app
         "string-more.rkt")

(module+ test
  (require rackunit))

(provide
 (contract-out
  [request->user-email (-> request? (or/c string? #f))]))


(define (identity-header->email maybe-header)
  (and maybe-header
       (identity-header-value->email maybe-header)))

(define (identity-header-string->email header-string)
  (and (email-identity? header-string)
       (email-identity->email header-string)))

(define identity-header-value->email
  (compose identity-header-string->email bytes->string/utf-8 header-value))

(define email-identity->email (string-drop (string-length "Email: ") _))
(define email-identity?  (string-starts-with? "Email: " _))

(define identity-header (headers-assq* #"Identity" _))
(define request->identity-header (compose identity-header request-headers/raw))
(define request->user-email (compose identity-header->email request->identity-header))

(module+ test
  (check string=? (identity-header->email (header #"Identity" #"Email: foo@bar")) "foo@bar")
  (check-false (identity-header->email (header #"Identity" #"foo"))))
