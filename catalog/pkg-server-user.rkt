#lang racket

(require web-server/http/request-structs)

(module+ test
  (require rackunit))

(provide
 (contract-out
  [request->user-email (-> request? (or/c string? #f))]))


(define (request->user-email req)
  (define headers (request-headers/raw req))
  (define user-agent (headers-assq* #"User-Agent" headers))
  (and user-agent (user-agent-email user-agent)))


(define user-agent-email-regexp (regexp "\\(Email: .+\\)"))

(module+ test
  (check-false (regexp-match? user-agent-email-regexp "Email: foo@bar"))
  (check-false (regexp-match? user-agent-email-regexp "(Email: )"))
  (check-true (regexp-match? user-agent-email-regexp "(Email: foo@bar)"))
  (check-false (regexp-match? user-agent-email-regexp "(email: foo@bar)"))
  (check-false (regexp-match? user-agent-email-regexp "( foo@bar)")))


(define (user-agent-email user-agent)
  (define user-agent-str (bytes->string/utf-8 user-agent))
  (define matches (regexp-match user-agent-email-regexp user-agent-str))
  (and (not (empty? matches))
       (user-agent-email-match->email (first matches))))

(define (user-agent-email-match->email email-match)
  (define chars (string->list email-match))
  (define without-prefix (drop chars 8))
  (apply string (drop-right without-prefix 1)))

(module+ test
  (check string=? (user-agent-email #"foof jkdlfkjlasf ksjdaf lkjasfl jfklds (Email: foo@bar.com) kljs") "foo@bar.com"))