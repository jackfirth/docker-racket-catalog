#lang racket

(require web-server/http/request-structs
         fancy-app
         "write-response.rkt"
         "pkg-server-request-details.rkt"
         "pkg-server-request-user.rkt"
         "pkg-detail.rkt"
         "pkg-catalog.rkt")

(provide author-only-handler)

(define (author-only-handler package-catalog handler request)
  (define maybe-error (ensure-author package-catalog request))
  (or maybe-error (handler request)))

(define (ensure-author package-catalog request)
  (define author (request->user-email request))
  (define name (req-pkg-name request))
  (define pkg-detail (pkg-details package-catalog name))
  (and pkg-detail
       (not (author-of-pkg? author pkg-detail))
       (package-access-disallowed-response author name)))

(define (package-access-disallowed-response author name)
  (write-forbidden-response (package-access-disallowed-message author name)))

(define (package-access-disallowed-message author name)
  (if author 
      (format "Request denied: User \"~a\" is not the author of package \"~a\"" author name)
      (format "Request denied: Modification of package \"~a\" requires identification" name)))
