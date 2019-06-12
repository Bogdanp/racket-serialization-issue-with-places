#lang racket/base

(require compiler/embed
         racket/file)

(define source-file
  "dynamic.rkt")

(define mod-sym
  (string->symbol
   (format "#%example:~a"
           (let-values ([(base name dir?)
                         (split-path source-file)])
             (path->bytes (path-replace-suffix name #""))))))

(make-directory* "build")
(create-embedding-executable
 "build/example"
 #:modules `((#%example: (file ,source-file) (main))
             (#%example/cart: (file "cart.rkt")))
 #:configure-via-first-module? #t
 #:literal-expression
 (parameterize ([current-namespace (make-base-namespace)])
   (define main-sym (string->symbol (format "~a(main)" mod-sym)))
   (compile
    `(begin
       (namespace-require '',mod-sym)
       (when (module-declared? '',main-sym)
         (dynamic-require '',main-sym #f))))))
