#lang racket/base

(require racket/serialize)

(provide
 current-cart
 (struct-out cart)
 load-cart!
 store-cart!)

(serializable-struct cart (item-ids)
  #:transparent)

(define current-cart
  (make-parameter (cart null)))

(define data-filepath
  "/tmp/example-cart.dat")

(define (load-cart!)
  (when (file-exists? data-filepath)
    (call-with-input-file data-filepath
      (lambda (in)
        (current-cart (deserialize (read in)))))))

(define (store-cart!)
  (call-with-output-file data-filepath
    #:exists 'truncate/replace
    (lambda (out)
      (write (serialize (current-cart)) out))))
