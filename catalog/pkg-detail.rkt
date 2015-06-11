#lang typed/racket

(require fancy-app)

(provide pkg-detail?)

(module+ test
  (require typed/rackunit))

(: hash-has-keys? (-> (Listof Any) HashTableTop Boolean))
(define (hash-has-keys? keys dict)
  (andmap (hash-has-key? dict _) keys))

(module+ test
  (check-true (hash-has-keys? '(a b) #hash((a . 1) (b . 2))))
  (check-true (hash-has-keys? '(a b) #hash((a . 1) (b . 2) (c . 3))))
  (check-false (hash-has-keys? '(a b) #hash((a . 1))))
  (check-false (hash-has-keys? '(a b) #hash((a . 1) (c . 3)))))

(: required-keys (Listof Symbol))
(define required-keys
  '(source checksum name))

(define (pkg-detail? v)
  (and (hash? v)
       (hash-eq? v)
       (hash-has-keys? required-keys v)))


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
