#lang typed/racket

(module+ test
  (require typed/rackunit))

(provide string-starts-with?
         string-drop)


(: string-starts-with? (-> String String Boolean))
(define (string-starts-with? prefix str)
  (and (<= (string-length prefix)
           (string-length str))
       (string=? (substring str 0 (string-length prefix))
                 prefix)))

(module+ test
  (check-true (string-starts-with? "foo" "fooklsflkjsf"))
  (check-false (string-starts-with? "foo" "foksljfklasjf"))
  (check-false (string-starts-with? "foo" "fo")))


(: string-drop (-> Integer String String))
(define (string-drop n str)
  (substring str n))

(module+ test
  (check string=? (string-drop 3 "foobar") "bar"))


