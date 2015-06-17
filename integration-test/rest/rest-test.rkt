#lang racket

(require "rest-param.rkt"
         rackunit)

(provide check-get
         check-get-exn
         check-get-not-exn
         check-put
         check-put-exn
         check-put-not-exn
         check-post
         check-post-exn
         check-post-not-exn
         check-delete
         check-delete-exn
         check-delete-not-exn)


(define-check (check-get location response)
  (check-equal? (get location) response))

(define-check (check-get-exn exn-pred location)
  (check-exn exn-pred (thunk (get location))))

(define-check (check-get-not-exn location)
  (check-not-exn (thunk (get location))))


(define-check (check-put location body response)
  (check-equal? (put location body) response))

(define-check (check-put-exn exn-pred location body)
  (check-exn exn-pred (thunk (put location body))))

(define-check (check-put-not-exn location body)
  (check-not-exn (thunk (put location body))))


(define-check (check-post location body response)
  (check-equal? (post location body) response))

(define-check (check-post-exn exn-pred location body)
  (check-exn exn-pred (thunk (post location body))))

(define-check (check-post-not-exn location body)
  (check-not-exn (thunk (post location body))))


(define-check (check-delete location response)
  (check-equal? (delete location) response))

(define-check (check-delete-exn exn-pred location)
  (check-exn exn-pred (thunk (delete location))))

(define-check (check-delete-not-exn location)
  (check-not-exn (thunk (delete location))))
