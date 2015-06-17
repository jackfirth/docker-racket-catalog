#lang racket

(require rackunit
         fancy-app
         "rest/main.rkt"
         "rest/rest-catalog.rkt"
         "mock-data.rkt")


(define current-requester (make-parameter #f))

(define-check (check-get location response)
  (check-equal? (get (current-requester) location) response))
(define-check (check-get-exn exn-pred location)
  (check-exn exn-pred (thunk (get (current-requester) location))))
(define-check (check-get-not-exn location)
  (check-not-exn (thunk (get (current-requester) location))))

(define-check (check-put location body response)
  (check-equal? (put (current-requester) location body) response))
(define-check (check-put-exn exn-pred location body)
  (check-exn exn-pred (thunk (put (current-requester) location body))))
(define-check (check-put-not-exn location body)
  (check-not-exn (thunk (put (current-requester) location body))))

(define catalog-container-requester (make-pkg-catalog-requester "http://catalog:8000"))

(define-syntax-rule (with-requester requester body ...)
  (parameterize ([current-requester requester]) body ...))

(define-syntax-rule (test-requester-begin requester check ...)
  (test-begin
   (with-requester requester
     check ...)))

(module+ test
  (test-requester-begin catalog-container-requester
    (check-get-not-exn "/pkgs")
    (check-get-not-exn "/pkgs-all")
    (check-get "/pkgs" '())
    (check-get "/pkgs-all" (hash))
    (check-put "/pkg/foo" foo-pkg-details foo-pkg-details)
    (check-get "/pkg/foo" foo-pkg-details)
    (check-get "/pkgs" '("foo"))
    (check-get "/pkgs-all" (hash "foo" foo-pkg-details))
    (check-put "/pkg/bar" bar-pkg-details bar-pkg-details)
    (check-get "/pkg/bar" bar-pkg-details)
    (check-get "/pkgs" '("bar" "foo"))
    (check-get "/pkgs-all" foo-bar-pkgs)
    (check-put-exn (http-exn-of-code? 403 _) "/pkg/foo" foo-pkg-details)))
