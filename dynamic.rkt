#lang racket/base

(require "cart.rkt"
         #;"hash.rkt"
         )

(load-cart!)
(displayln (current-cart))
(current-cart (cart '(1 2 3)))
#;(make-password-hash "test")
(store-cart!)
