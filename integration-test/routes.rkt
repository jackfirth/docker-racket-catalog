#lang racket

(require rackunit
         fancy-app
         "fetch.rkt")

(provide check-route-up
         check-route-get
         check-route-get-pred
         check-route-put
         check-route-delete)


(define (route->url-string route)
  (string-append "http://catalog:8000" route))

(define fetch-route (compose fetch route->url-string))
(define fetch-route/read (compose fetch/read route->url-string))

(define (put-route/write route v)
  (put/write (route->url-string route) v))

(define delete-route (compose delete route->url-string))
(define delete-route/read (compose delete/read route->url-string))

(define-syntax-rule (with-route-response id proc route body ...)
  (let* ([id (proc route)]
         [route-info (make-check-info 'route route)]
         [response-info (make-check-info 'response id)])
    (with-check-info* (list route-info response-info)
                      (thunk body ...))))

(define-syntax-rule (with-route-get-response id route body ...)
  (with-route-response id fetch-route/read route body ...))

(define-syntax-rule (with-route-put-response id route v body ...)
  (with-route-response id (put-route/write _ v) route body ...))

(define-syntax-rule (with-route-delete-response id route body ...)
  (with-route-response id delete-route/read route body ...))

(define-check (check-route-up route)
  (check-not-exn (thunk (fetch-route route))))

(define-check (check-route-get route expected-read-value)
  (with-route-get-response response route
                           (check-equal? response expected-read-value)))

(define-check (check-route-get-pred route pred)
  (with-route-get-response response route
                       (check-pred pred response)))

(define-check (check-route-put route write-value)
  (with-route-put-response response route write-value
                           (check-equal? response write-value)))

(define-check (check-route-delete route)
  (with-route-delete-response response route
                              (check-true response)))
