#lang racket

(require web-server/http/request-structs
         spin
         fancy-app
         "pkg-detail.rkt")

(provide
 (contract-out
  [get-req-pkg-details (-> request? pkg-detail?)]
  [req-pkg-name (-> request? string?)]))


(define get-req-pkg-details
  (compose read
           open-input-string
           bytes->string/utf-8
           request-post-data/raw))

(define req-pkg-name (params _ 'name))
