# Docker images for YAML Runtimes

This repository provides Dockerfiles for several YAML processors. The goal is
to be able to compare the behaviour of the most common processors.

Providing runtime environments makes it easier to test and compare, and
eventually create bugreports.

This repo is built after the idea of the [YAML
Editor](https://github.com/yaml/yaml-editor). The difference to YAML Editor is
that the docker images are split up into several ones by language/type to create
smaller images and allow to only build or download the containers you need.

Each library has one or more programs to process YAML input and output parsing
events or JSON. In the docker images they can be found under the `/yaml`
directory.

There is also a `runtime-all` image which contains all processors (as long as
we can build all processors on Alpine Linux).

## Usage

Requirements:
* perl
* YAML::PP module
* jq

To install YAML::PP, run (debian example):

    apt-get install cpanminus
    cpanm YAML::PP

To install the module locally instead, do this:

    cpanm -l local YAML::PP
    export PERL5LIB=$PWD/local/lib/perl5

To list all libraries:

    make list

### Build

To build all images, do

    make build

You can also just build a single environment or library:

    # build all javascript libraries
    make node
    # build C libyaml
    make c-libyaml
    # build perl5 YAML::PP
    make perl5-pp

### Test

To see if the build was successful and all programs work, run

    make test
    # or verbose:
    make testv

This will test each program with a simple YAML file.

To test only one runtime or library:

    make test LIBRARY=c-libyaml
    make testv RUNTIME=perl5
    make testv RUNTIME=all LIBRARY=hs-hsyaml

## Architecture

So far all docker images are based on Alpine Linux.

For each environment there is a builder image and a runtime image.
The libraries are built in the builder containers, and all necessary
files are then copied into the runtime images.

## Libraries

Currently only official releases of the libraries are build. Allowing to
build from sources like git might be added at some point.

Look into [list.yaml](list.yaml) to see the current list.
