#lang racket

(require fancy-app)

(provide
 (contract-out
  [pkg-detail? predicate/c]))

(module+ test
  (require rackunit))

  
(define (dict-has-keys? keys dict)
  (andmap (dict-has-key? dict _) keys))

(module+ test
  (check-true (dict-has-keys? '(a b) #hash((a . 1) (b . 2))))
  (check-true (dict-has-keys? '(a b) #hash((a . 1) (b . 2) (c . 3))))
  (check-false (dict-has-keys? '(a b) #hash((a . 1))))
  (check-false (dict-has-keys? '(a b) #hash((a . 1) (c . 3)))))


(define required-keys
  '(source checksum name))

(define (pkg-detail? v)
  (and (hash-eq? v)
       (dict-has-keys? required-keys v)))


(module+ test
  (check-true (pkg-detail? #hasheq((source . "path/to/foo")
                                   (checksum . 0)
                                   (name . "foo"))))
  (check-true (pkg-detail? #hasheq((source . "path/to/foo")
                                   (checksum . 0)
                                   (name . "foo")
                                   (extra . "blah"))))
  (check-false (pkg-detail? #hasheq((source . "path/to/foo")
                                   (checksum . 0)))))
