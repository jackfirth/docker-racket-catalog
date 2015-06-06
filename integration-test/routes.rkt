#lang racket

(require rackunit
         "fetch.rkt")

(provide check-route-up
         check-route-get
         check-route-get-pred)


(define (route->url-string route)
  (string-append "http://catalog:8000" route))

(define fetch-route (compose fetch route->url-string))
(define fetch-route/read (compose fetch/read route->url-string))

(define-syntax-rule (with-route-response id route body ...)
  (let* ([id (fetch-route/read route)]
         [route-info (make-check-info 'route route)]
         [response-info (make-check-info 'response id)])
    (with-check-info* (list route-info response-info)
                      (thunk body ...))))

(define-check (check-route-up route)
  (check-not-exn (thunk (fetch-route route))))

(define-check (check-route-get route expected-read-value)
  (with-route-response response route
                       (check-equal? response expected-read-value)))

(define-check (check-route-get-pred route pred)
  (with-route-response response route
                       (check-pred pred response)))
