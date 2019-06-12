#lang racket/base

(require racket/place)

(provide
 hasher-start)

(define (hasher-start)
  (place ch
    (let loop ()
      (define s (place-channel-get ch))
      (place-channel-put (string-upcase s))
      (loop))))
