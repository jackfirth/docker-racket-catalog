#lang racket

(require rackunit
         fancy-app
         "rest/rest-param.rkt"
         "rest/rest-test.rkt"
         "rest/rest-catalog.rkt"
         "mock-data.rkt")


(define catalog-container-requester (make-pkg-catalog-requester "http://catalog:8000"))

(define foo-user-headers '("Identity: Email: foo@baz"))
(define as-foo-user (wrap-requester-headers foo-user-headers _))

(define http-forbidden-exn? (http-exn-of-code? 403 _))
(define http-not-found-exn? (http-exn-of-code? 404 _))

(module+ test
  (test-begin
   (with-requester catalog-container-requester
     
     (check-get-not-exn "/pkgs")
     (check-get-not-exn "/pkgs-all")
     (check-get "/pkgs" '())
     (check-get "/pkgs-all" (hash))
     
     (check-get-exn http-not-found-exn? "/pkg/foo")
     (check-put "/pkg/foo" foo-pkg-details foo-pkg-details)
     (check-get "/pkg/foo" foo-pkg-details)
     (check-get "/pkgs" '("foo"))
     (check-get "/pkgs-all" (hash "foo" foo-pkg-details))
     
     (check-get-exn http-not-found-exn? "/pkg/bar")
     (check-put "/pkg/bar" bar-pkg-details bar-pkg-details)
     (check-get "/pkg/bar" bar-pkg-details)
     (check-get "/pkgs" '("bar" "foo"))
     (check-get "/pkgs-all" foo-bar-pkgs)
     
     (check-put-exn http-forbidden-exn? "/pkg/foo" foo-pkg-details)
     (check-delete-exn http-forbidden-exn? "/pkg/foo"))

   (with-requester (as-foo-user catalog-container-requester)

     (check-put-not-exn "/pkg/foo" foo-pkg-details)
     (check-put-exn http-forbidden-exn? "/pkg/bar" bar-pkg-details))))
