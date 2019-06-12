# #2693

This is a minimal example that reproduces [racket #2693](https://github.com/racket/racket/issues/2693).

## Solution

Per @mflatt, the issue is that the generation of embedded module names
is non-deterministic so changing the order in which modules are
required can affect their embedded names, which, in turn, affects
whether or not they can be loaded upon deserialization.

One way to work around this right now is to build executables directly
with `create-embedding-executable` instead of the `raco exe` command
and explicitly prefixing the modules that use `serializable-struct` in
its `#:modules` list.

See `build.rkt` for an example usage of that function.

## Original issue statement

    I've recently introduced places into my app and noticed that, upon deployment, the app would fail to start with an error when it tried to deserialize some data off of disk. The error looks something like this:

    ```racket
    dynamic-require: unknown module
      module name: #<resolved-module-path:'#%embedded:g764:cart>
      context...:
       do-dynamic-require5
       /Applications/Racket v7.3/collects/racket/private/serialize.rkt:693:8: loop
       /Applications/Racket v7.3/collects/racket/private/serialize.rkt:688:2: deserialize
       /Users/bogdan/tmp/example/cart.rkt:23:6: temp4
       '#%mzc:dynamic: [running body]
       temp37_0
       for-loop
       run-module-instance!125
       perform-require!78
       top-level: [running body]
       eval-one-top12
       loop
       [repeats 1 more time]
    ```

    The issue seems to have to do with how serialization and places interact but I'm unsure how to dig in further at this point.  I've been able to reproduce the issue both on macOS and on Linux, each running the latest stable builds of Racket 7.3 for their respective platforms.  The issue is only present when you create a distribution from the code.  Running `racket example/dynamic.rkt` does not reproduce this problem.

    After deleting the serialized file, the problem disappeared and I have been able to successfully deploy new versions of the app since so it seems that introducing places into a program is currently a backwards-incompatible change as far as serialization is concerned. Distributions built before the places were introduced into the program seem to be able to deserialize data that was serialized after they were introduced.

    I've created a [minimal example repo](https://github.com/Bogdanp/racket-serialization-issue-with-places) that you can use to reproduce this issue. The steps to reproduce are:

    1. clone the repository and cd into its parent folder,
    2. build a distribution with

    ```bash
    mkdir -p build && \
      raco exe -o build/example example/dynamic.rkt && \
      raco distribute dist build/example
    ```

    3. run the distribution `./dist/bin/example`,
    4. uncomment lines 4 and 9 in `example/dynamic.rkt`,
    5. build another distribution with the same series of commands as above,
    6. run the distribution again and you should receive an error akin to what I've posted above.

    Note that the code will write a file to `/tmp/example-cart.dat` unless modified.

    Thanks!
