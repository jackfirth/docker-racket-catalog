#lang typed/racket

(require fancy-app)

(provide pkg-detail?
         author-of-pkg?
         PackageDetail)

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
  '(source name author))

(define (pkg-detail? v)
  (and (hash? v)
       (hash-has-keys? required-keys v)))

(define-type PackageDetail (HashTable Symbol Any))

(: author-of-pkg? (-> Any PackageDetail Boolean))
(define (author-of-pkg? author pkg-detail)
  (equal? author (hash-ref pkg-detail 'author)))


(module+ test
  (check-true (pkg-detail? #hasheq((source . "path/to/foo")
                                   (name . "foo")
                                   (author . "foo@bar"))))
  (check-true (pkg-detail? #hasheq((source . "path/to/foo")
                                   (name . "foo")
                                   (author . "foo@bar")
                                   (extra . "blah"))))
  (check-false (pkg-detail? #hasheq((source . "path/to/foo")))))
