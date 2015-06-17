#lang racket

(require fancy-app
         "rest-struct.rkt"
         "rest-wrap.rkt"
         "call-response.rkt")

(provide requester-pure)


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

(define (request-error-message handler-response)
  (define code (response-code handler-response))
  (format "~a: ~a\nbody: ~a"
          code
          (code->message code)
          (response-body handler-response)))

(define (raise-request-error handler-response)
  (raise
   (exn:fail:network
    (request-error-message handler-response)
    (current-continuation-marks))))

(define failure-code? (<= 400 _ 600))

(define (check-code handler-response)
  (when (failure-code? (response-code handler-response))
    (raise-request-error handler-response)))

(define (parse-response handler-response)
  (check-code handler-response)
  (response-body handler-response))

(define requester-pure (wrap-requester-response parse-response _))
