#lang racket

(require "pkg-catalog.rkt"
         "pkg-server.rkt"
         "redis-catalog.rkt"
         fancy-app
         spin
         redis)


(set-catalog-routes redis-catalog)

(module+ main
  (displayln "Running...")
  (run #:listen-ip #f
       #:port 8000))
