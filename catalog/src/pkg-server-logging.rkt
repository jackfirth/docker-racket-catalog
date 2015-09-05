#lang typed/racket

(provide log-get
         log-delete
         log-get-pkgs
         log-get-all
         log-put)

(require "logger.rkt")


(: log-get (-> String Void))
(define log-get (logger "GET"))

(: log-delete (-> String Void))
(define log-delete (logger "DELETE"))

(: log-get-pkgs (-> Void))
(define log-get-pkgs (const-logger "GET PKGS"))

(: log-get-all (-> Void))
(define log-get-all (const-logger "GET ALL PKG DETAILS"))

(: log-put (-> String Void))
(define log-put (logger "PUT"))
