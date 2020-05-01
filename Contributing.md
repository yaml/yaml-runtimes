## Contributing to [yaml-runtimes](https://github.com/yaml/yaml-runtimes)

If you know a YAML library not yet in yaml-runtimes, maybe you would be able
to add it here?

## General Git Practices

Commit message subjects should ideally be shorter than 60 characters and be like
```
* Add foo to bar

Longer description, if necessary.
Fixes #issue-id.
```

* We usually don't make merge commits, except for longer branches.
* All branches should be rebased before merging.
* Merges only happen from branches into master, but not the other
  way around.

If you create a PR, it's recommended that you do this from a branch.

## Project Layout

Under the `docker/` directory you will find a directory for each runtime:

    docker/
    ├── Dockerfile
    ├── dotnet
    ├── global
    ├── haskell
    ├── ...

In a runtime, there are two docker files, one for building the library, and
one for running, without the development libraries installed.

    docker/static/
    ├── alpine-builder.dockerfile
    ├── alpine-runtime.dockerfile

Then there is a `testers/` directory which contains the programs to run the
YAML processor. These are symlinks to compiled excutables, shell wrappers, or
script files:

    ├── testers
    │   ├── c-libfyaml-event
    │   ├── c-libyaml-event
    │   └── ...

The `utils/` directory contains shell scripts to build the libraries, and
other necessary sources:

    └── utils
        ├── c-libfyaml-build.sh
        ├── c-libyaml-build.sh
        ├── run-parser-test-suite.c
        └── ...

## Adding a YAML processor

Let's say you want to add a new Javascript library `foo`, and it supports
event output and JSON output.

Add all necessary information to `list.yaml`.

Add the following files:
* `docker/node/utils/js-foo-build.sh`
* `docker/node/testers/js-foo-event`
* `docker/node/testers/js-foo-json`

Type

    make js-foo

and it will build the builder image (if necessary) and the runtime image.

Test:

    make testv LIBRARY=js-foo
