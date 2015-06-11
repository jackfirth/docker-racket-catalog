#lang typed/racket

(provide logger
         const-logger)


(: displayln/f (-> Any Void))
(define (displayln/f v)
  (displayln v)
  (flush-output))

(: logger (-> String (-> String Void)))
(define ((logger prefix) str)
  (displayln/f (string-append prefix " " str)))

(: const-logger (-> String (-> Void)))
(define ((const-logger str))
  (displayln/f str))
