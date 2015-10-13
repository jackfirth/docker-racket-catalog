#lang racket

(require fancy-app
         "rest-struct.rkt"
         "rest-wrap.rkt"
         "call-response.rkt")

(provide (struct-out exn:fail:network:http)
         requester-pure
         http-exn-of-code?)


(define message-codes
  (hash 400 "Bad Request"
        401 "Unauthorized"
        402 "Payment Required"
        403 "Forbidden"
        404 "Not Found"
        405 "Method Not Allowed"
        406 "Not Acceptable"
        407 "Proxy Authentication Required"
        408 "Request Timeout"
        409 "Conflict"
        410 "Gone"
        411 "Length Required"
        412 "Precondition Failed"
        500 "Internal Server Error"
        501 "Not Implemented"
        502 "Bad Gateway"
        503 "Service Unavailable"
        504 "Gateway Timeout"))

(define code->message (hash-ref message-codes _))

(struct exn:fail:network:http exn:fail:network (code) #:transparent)

(define (make-http-exn handler-response)
  (define code (response-code handler-response))
  (define body (response-body handler-response))
  (exn:fail:network:http (~a body) (current-continuation-marks) code))

(define (http-exn-of-code? code v)
  (and (exn:fail:network:http? v)
       (= code (exn:fail:network:http-code v))))

(define (raise-request-error handler-response)
  (raise (make-http-exn handler-response)))

(define failure-code? (<= 400 _ 600))

(define (check-code handler-response)
  (when (failure-code? (response-code handler-response))
    (raise-request-error handler-response)))

(define (parse-response handler-response)
  (check-code handler-response)
  (response-body handler-response))

(define requester-pure (wrap-requester-response parse-response _))