#lang racket/base

(require racket/place
         "hasher.rkt")

(provide
 make-password-hash)

(define hasher-ch (hasher-start))

(define (make-password-hash p)
  (place-channel-put/get hasher-ch p))
